class Polkadot::ValidatorSummary < Common::Resource
  field :total_stake_avg, type: :integer
  field :uptime_avg, type: :float
  field :time_bucket, type: :timestamp

  def total
    total_stake_avg
  end

  def uptime_avg
    @uptime_avg || 1
  end

  def indexing_completed?(last_indexed_timestamp)
    @time_bucket < last_indexed_timestamp
  end
end
