class Polkadot::ValidatorsSummary < Common::Resource
  field :total_stake_avg, type: :integer
  field :validators_count, type: :integer
  field :time_bucket, type: :timestamp

  def total_stake
    total_stake_avg * validators_count
  end
end
