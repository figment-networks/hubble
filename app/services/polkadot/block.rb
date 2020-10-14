module Polkadot
  class Block < Common::Resource
    field :height
    field :time, type: :timestamp
    field :hash
    field :extrinsics

    def transactions
      @transactions ||= Polkadot::Transaction.from_block(self)
    end
  end
end
