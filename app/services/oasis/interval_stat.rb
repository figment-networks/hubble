module Oasis
  class IntervalStat < Common::Resource
    field :id
    field :created_at, type: :timestamp
    field :updated_at, type: :timestamp
    field :time_interval
    field :time_bucket
    field :count
    field :voting_power_avg
    field :voting_power_max
    field :voting_power_min
    field :total_shares_avg
    field :total_shares_max
    field :total_shares_min
    field :validated_sum
    field :not_validated_sum
    field :proposed_sum
    field :block_time_avg
    field :entity_uid
    field :voting_power_avg
    field :voting_power_max
    field :voting_power_min
    field :total_shares_min
    field :total_shares_max
    field :total_shares_avg
    field :validated_sum
    field :not_validated_sum
    field :proposed_sum
    field :uptime_avg
    field :index_version
    field :active_escrow_balance_avg
    field :active_escrow_balance_max
    field :active_escrow_balance_min
    field :commission_avg
    field :commission_max
    field :commission_min

    def point
      { t: Time.zone.parse(time_bucket).iso8601, y: block_time_avg || uptime_avg }
    end
  end
end
