class Polkadot::ValidatorSummary < Common::Resource
  field :total_stake_avg, type: :integer
  field :uptime_avg, type: :float
  field :time_bucket, type: :timestamp

  def total_stake
    total_stake_avg
  end
end
