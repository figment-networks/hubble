class Celo::BlocksSummary < Common::Resource
  field :block_time_avg, type: :float, default: 0
  field :time_bucket, type: :timestamp

  def total
    block_time_avg
  end
end
