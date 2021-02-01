module Polkadot
  class Transaction < Common::Resource
    field :hash
    field :is_signed
    field :block
    field :signature
    field :account
    field :nonce, type: :integer
    field :method_name
    field :section
    field :args
    field :is_success
    field :time
    field :partial_fee, type: :integer
    field :tip, type: :integer

    def initialize(attributes = {})
      attributes['method_name'] = attributes.delete('method')
      attributes['account'] = attributes.delete('public_key')
      attributes['partial_fee'] ||= attributes.delete('partialFee') # TODO: remove when indexer gets updated
      super(attributes)
    end

    def fee
      partial_fee + tip
    end

    def self.from_block(block)
      block.extrinsics.
        select { |extrinsic| extrinsic['is_signed'] }.
        map { |extrinsic| new(extrinsic.merge({ 'block' => block.height, 'time' => block.time })) }
    end
  end
end
