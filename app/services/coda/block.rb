module Coda
  class Block < Resource
    field :height
    field :time, type: :timestamp
    field :hash
    field :parent_hash
    field :ledger_hash
    field :creator
    field :coinbase
    field :total_currency
    field :epoch
    field :slot
    field :transactions_count
    field :fee_transfers_count
    field :snarkers_count
    field :snark_jobs_count
    field :snark_jobs_fees

    def producer?(public_key)
      creator == public_key
    end
  end
end
