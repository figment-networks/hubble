class Celo::ValidatorGroupsSummary < Common::Resource
  field :active_votes_avg, type: :integer, default: 0
  field :pending_votes_avg, type: :integer, default: 0
  field :validator_groups_count, type: :integer, default: 0
  field :time_bucket, type: :timestamp

  def total
    (active_votes_avg + pending_votes_avg) * validator_groups_count
  end
end
