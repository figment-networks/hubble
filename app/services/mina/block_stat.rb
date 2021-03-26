module Mina
  class BlockStat < Common::Resource
    include TimeHelper

    field :time, type: :timestamp
    field :blocks_count
    field :block_time_avg
    field :validators_count
    field :snarkers_count
    field :jobs_count
    field :jobs_amount, type: :integer
    field :transactions_count
    field :transactions_amount, type: :integer
    field :payments_count
    field :payments_amount, type: :integer
    field :fee_transfers_count
    field :fee_transfers_amount, type: :integer
    field :coinbase_count
    field :coinbase_amount, type: :integer

    def block_minutes_avg
      seconds_in_minutes(block_time_avg).round(2)
    end
  end
end
