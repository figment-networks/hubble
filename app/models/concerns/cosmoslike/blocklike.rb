module Cosmoslike::Blocklike
  extend ActiveSupport::Concern

  included do |klass|
    namespace = klass.name.deconstantize.constantize

    belongs_to :chain, class_name: "#{namespace}::Chain"

    default_scope { order('height DESC') }

    validates :height, presence: true, uniqueness: { scope: :chain }
    validates :id_hash, presence: true, uniqueness: { scope: :chain }
    validates :timestamp, presence: true
  end

  def to_param
    height.to_s
  end

  def previous_block
    chain.blocks.find_by(height: height - 1)
  end

  def next_block
    chain.blocks.find_by(height: height + 1)
  end

  def proposer
    return nil if proposer_address.blank?

    chain.validators.find_by(address: proposer_address)
  end

  def validator_in_set?(validator)
    validator_set.keys.include?(validator.address)
  end

  def transaction_objects
    return [] if transactions.nil?

    begin
      transactions.map { |hash| chain.namespace::TransactionDecorator.new(chain, hash) }
    rescue StandardError
      nil
    end
  end

  module ClassMethods
    def assemble_from_cache(chain, height)
      Rails.cache.fetch(['block', chain.network_name.downcase, chain.ext_id.to_s,
                         height.to_s].join('-')) do
        assemble(chain, height)
      end
    end

    def assemble(chain, height, block_meta = nil, raw_commit = nil, raw_validator_set = nil)
      if block_meta.nil?
        # we're building this block from scratch with no data
        begin
          syncer = chain.namespace::SyncBase.new(chain, 250)
          raw_block = syncer.get_block(height)['result']
          block_txs = raw_block['block']['data']['txs']
          block_meta = raw_block['block_meta'] || raw_block['block']
        rescue StandardError
          raise chain.namespace::SyncBase::CriticalError, "Unable to retrieve or invalid object for block #{height}."
        end

        raw_commit = syncer.get_commit(height)
        raw_validator_set = syncer.get_validator_set(height)
      else
        # we don't need to look up the whole block unless
        # there are transactions in the block
        begin
          if block_meta['num_txs'].to_i > 0 || block_meta['header']['num_txs'].to_i > 0
            syncer = chain.namespace::SyncBase.new(chain, 250)
            block_txs = syncer.get_block(height)['result']['block']['data']['txs']
          end
        rescue StandardError
          raise chain.namespace::SyncBase::CriticalError, "Unable to retrieve or invalid transaction info for block #{height}."
        end
      end

      begin
        # tendermint 0.33+ changed the key to 'signatures'
        precommitters = raw_commit['result']['signed_header']['commit']['precommits'] ||
                        raw_commit['result']['signed_header']['commit']['signatures']
        addresses = precommitters.map do |pc|
          pc['validator_address'] rescue nil
        end .compact.reject(&:blank?)
      rescue StandardError
        raise chain.namespace::SyncBase::CriticalError, "Invalid validator/precommitter list for block #{height}."
      end

      begin
        validator_set = raw_validator_set.
          each_with_object({}) do |o, h|
            h[o['address']] = process_voting_power(o['voting_power'].to_i, chain)
          end.
          reject { |k, _v| k.blank? }
      rescue StandardError
        puts raw_validator_set.inspect
        puts $!.message
        puts $!.backtrace.join("\n")
        raise chain.namespace::SyncBase::CriticalError, "Invalid validator voting set information for block #{height}."
      end

      begin
        transactions = block_txs.try(:map) do |data|
          Digest::SHA256.hexdigest(Base64.decode64(data))
        end
      rescue StandardError
        raise chain.namespace::SyncBase::CriticalError, "Unable to decode or invalid transaction data for block #{height}."
      end

      # Another patch, for Kava 4
      id_hash = block_meta.try(:[], 'block_id').try(:[], 'hash') || raw_block.try(:[], 'block_id').try(:[], 'hash')

      obj = {
        chain_id: chain.id,
        height: height,
        id_hash: id_hash,
        timestamp: block_meta['header']['time'].to_datetime,
        proposer_address: block_meta['header']['proposer_address'],
        precommitters: addresses,
        validator_set: validator_set,
        transactions: transactions
      }

      if (t = new(obj)).invalid?
        puts "Invalid block at height: #{height}\n#{obj.inspect}\nError description: #{t.errors.full_messages.join(', ')}\n\n"
        raise chain.namespace::SyncBase::CriticalError, "Invalid block at height #{height}."
      end

      obj
    end

    def stub_from_cache(*args)
      new(assemble_from_cache(*args))
    end

    def stub(*args)
      new(assemble(*args))
    end

    protected

    def process_voting_power(voting_power, _chain)
      # by default cosmos-sdk projects report voting power in
      # equiv of uatom
      voting_power
    end
  end
end
