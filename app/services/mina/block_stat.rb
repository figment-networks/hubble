module Mina
  class BlockStat < Common::Resource
    field :time, type: :timestamp
    field :blocks_count
    field :block_time_avg
    field :validators_count
    field :snarkers_count
    field :transactions_count
    field :jobs_count
  end
end
