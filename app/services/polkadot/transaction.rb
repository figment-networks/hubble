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
                  :time

    def initialize(attrs = {})
      attrs["method_name"] = attrs.delete("method")
      attrs["account"] = attrs.delete("signer")
      super(attrs)
      @time = Time.zone.parse(time)
    end

    def id
      hash
    end

    def self.from_block(block)
      block.extrinsics.
        select { |extrinsic| extrinsic['is_signed'] }.
        map { |extrinsic| new(extrinsic.merge({ 'block' => block.height })) }
    end
  end
end
