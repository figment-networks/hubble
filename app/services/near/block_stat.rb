module Near
  class BlockStat < Common::Resource
    field :time, type: :timestamp
    field :bucket
    field :blocks_count
    field :block_time_avg
    field :validators_count
    field :transactions_count

    def block_time_point
      { t: time.iso8601, y: block_time_avg }
    end

    def validators_count_point
      { t: time.iso8601, y: validators_count }
    end
  end
end
