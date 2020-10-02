module Polkadot
  class Block < Common::Resource
    attr_accessor :chain,
                  :spec_version,
                  :height,
                  :time,
                  :hash,
                  :parent_hash,
                  :extrinsics_root,
                  :state_root,
                  :extrinsics

    def initialize(attributes = {})
      super(attributes)
      @time = Time.zone.parse(time)
    end

    def transactions
      Polkadot::Transaction.from_block(self)
    end
  end
end
