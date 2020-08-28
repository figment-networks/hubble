module Polkadot
  class Block < Common::Resource
    attr_accessor :chain,
                  :spec_version,
                  :session,
                  :era,
                  :height,
                  :time,
                  :hash,
                  :parent_hash,
                  :extrinsics_root,
                  :state_root,
                  :extrinsics

    def initialize(attrs = {})
      super(attrs)
      @time = Time.zone.parse(time)
    end

    def transactions
      Polkadot::Transaction.from_block(self)
    end
  end
end
