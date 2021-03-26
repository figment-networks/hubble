module Mina
  class Block < Common::Resource
    field :height
    field :time, type: :timestamp
    field :hash
    field :parent_hash
    field :ledger_hash
    field :creator
    field :coinbase, type: :integer
    field :total_currency, type: :integer, default: 0
    field :epoch
    field :slot
    field :transactions_count
    field :fee_transfers_count
    field :snarkers_count
    field :snark_jobs_count
    field :snark_jobs_fees
    field :canonical

    def producer?(public_key)
      creator == public_key
    end
  end
end
