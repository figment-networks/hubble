module Polkadot
  class Validator < Common::Resource
    COMMISSION_PERCENTAGE_FACTOR = 10 ** 8

    attr_accessor :stash_account,
                  :accumulated_uptime,
                  :online,
                  :total_stake,
                  :commission,
                  :account_details,
                  :own_stake,
                  :commission,
                  :reward_points,
                  :started_at

    alias online? online

    def commission_percentage
      return 0 if commission <= 0

      commission / COMMISSION_PERCENTAGE_FACTOR
    end

    def initialize(attributes = {})
      super(attributes)
      @started_at = Time.zone.parse(started_at) if started_at
    end
  end
end
