class Polkadot::ValidatorsSummary < Common::Resource
  field :total_stake_avg, type: :integer
  field :validators_count, type: :integer
  field :time_bucket, type: :timestamp

  def total
    total_stake_avg * validators_count
  end

  def indexing_completed?(last_indexed_timestamp)
    @time_bucket < last_indexed_timestamp
  end
end
