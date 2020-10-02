module Polkadot
  class Transaction < Common::Resource
    attr_accessor :extrinsic_index,
                  :hash,
                  :is_signed,
                  :block,
                  :signature,
                  :account,
                  :nonce,
                  :method_name,
                  :section,
                  :args,
                  :is_success,
                  :time,
                  :partial_fee,
                  :tip

    def initialize(attributes = {})
      attributes['method_name'] = attributes.delete('method')
      attributes['account'] = attributes.delete('public_key')
      attributes['partial_fee'] = attributes.delete('partialFee') # TODO: remove when indexer gets updated
      super(attributes)
      @partial_fee = partial_fee.to_i
      @tip = tip.to_i
    end

    def id
      hash
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
