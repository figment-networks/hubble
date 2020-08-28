module Cosmoslike::Validatorlike
  extend ActiveSupport::Concern

  included do |klass|
    namespace = klass.name.deconstantize.constantize

    belongs_to :chain, class_name: "#{namespace}::Chain"
    has_many :events, as: :validatorlike, class_name: 'Common::ValidatorEvent'
    has_many :latches, as: :validatorlike, class_name: 'Common::ValidatorEventLatch'
    has_many :alert_subscriptions, as: :alertable

    has_one :account, class_name: "#{namespace}::Account"

    validates :address, presence: true, allow_blank: false, uniqueness: { scope: :chain }

    before_save :promote_owner
    before_save :promote_moniker
  end

  def to_param; address; end

  module ClassMethods
    def total_voting_power( chain )
      sum(:current_voting_power)
    end
  end

  def has_info?
    (info||{}).any?
  end

  def short_name( max_length=16 )
    (!moniker.blank? ? moniker : nil) ||
    owner ||
    address.truncate( max_length )
  end

  def long_name
    moniker || owner || address
  end

  def name_and_owner
    moniker.blank? ? owner : "#{moniker} - #{owner}"
  end

  def retrieve_owner
    info_field( 'owner' ) || info_field( 'operator_address' )
  end

  def owner
    self[:owner] || retrieve_owner
  end

  def retrieve_moniker
    info_field( 'description', 'moniker' ) || nil
  end

  def moniker
    self[:moniker] || retrieve_moniker
  end

  def current_commission
    rate = info_field( 'commission', 'rate' )
    rate ? rate.to_f : nil
  end

  def max_commission
    max = info_field( 'commission', 'max_rate' )
    max ? max.to_f : nil
  end

  def commission_change_rate
    rate = info_field( 'commission', 'max_change_rate' )
    rate ? rate.to_f : nil
  end

  def proposals
    return [] unless account
    ids = [
      *account.governance_deposits.select('DISTINCT proposal_id'),
      *account.governance_votes.select('DISTINCT proposal_id')
    ].map(&:proposal_id).uniq
    chain.governance_proposals.where( id: ids )
  end

  def recent_events( type, since )
    events.where( type: type.to_s ).where( 'timestamp >= ?', since )
  end

  def in_active_set?( block=nil )
    if block.nil?
      block = chain.blocks.first
    end
    block.validator_set.keys.include?( address )
  end

  def voting_power_history
    events.where( type: 'Common::ValidatorEvents::VotingPowerChange' )
  end
  def active_set_history
    events.where( type: 'Common::ValidatorEvents::ActiveSetInclusion' )
  end

  def info_field( *fields )
    begin
      current = info
      fields.each do |f|
        current = current[f.to_s]
      end
      current.blank? ? nil : current
    rescue
      nil
    end
  end

  def voting_power_at_height( height )
    block = chain.blocks.find_by( height: height ) || Cosmos::Block.stub_from_cache( chain, height )
    block.validator_set[self.address]
  end

  def last_precommitted_block
    # this is too damn slow
    # chain.blocks.where( 'precommitters @> ARRAY[?]::varchar[]', address ).first

    return nil if latest_block_height.nil? || latest_block_height.zero?
    chain.blocks.find_by( height: latest_block_height ) ||
    Cosmos::Block.stub( chain, latest_block_height )
  end

  def proposal_probability
    total = chain.validators.sum(:current_voting_power)
    return 0 if total.zero?
    current_voting_power / total.to_f
  end

  def active?
    (current_voting_power||0) > 0
  end

  def calculate_current_uptime( blocks_num: 100 )
    blocks = chain.blocks.limit( blocks_num )
    num_blocks = blocks.count
    return 0.0 if num_blocks.zero?

    precommits = blocks
      .select { |b| b.precommitters.include?(address) }
      .count

    (precommits / blocks.count.to_f).round(2)
  end

  private

  def promote_owner
    new_owner = retrieve_owner
    if self[:owner].nil? || !new_owner.nil?
      self[:owner] = new_owner
    end
  end

  def promote_moniker
    new_moniker = retrieve_moniker
    if self[:moniker].nil? || !new_moniker.nil?
      self[:moniker] = new_moniker
    end
  end
end
