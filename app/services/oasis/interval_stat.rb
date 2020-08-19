module Oasis
  class IntervalStat < Common::Resource
    attr_accessor :id,
                  :created_at,
                  :updated_at,
                  :time_interval,
                  :time_bucket,
                  :count,
                  :voting_power_avg,
                  :voting_power_max,
                  :voting_power_min,
                  :total_shares_avg,
                  :total_shares_max,
                  :total_shares_min,
                  :validated_sum,
                  :not_validated_sum,
                  :proposed_sum,
                  :block_time_avg,
                  :entity_uid,
                  :voting_power_avg,
                  :voting_power_max,
                  :voting_power_min,
                  :total_shares_min,
                  :total_shares_max,
                  :total_shares_avg,
                  :validated_sum,
                  :not_validated_sum,
                  :proposed_sum,
                  :uptime_avg,
                  :index_version,
                  :active_escrow_balance_avg,
                  :active_escrow_balance_max,
                  :active_escrow_balance_min,
                  :commission_avg,
                  :commission_max,
                  :commission_min

    def point
      { t: Time.zone.parse(time_bucket).iso8601, y: block_time_avg || uptime_avg }
    end
  end
end
