module Polkadot
  class Validator < Common::Resource
    COMMISSION_PERCENTAGE_FACTOR = 10 ** 8

    attr_accessor :stash_account,
                  :accumulated_uptime,
                  :online,
                  :total_stake,
                  :commission,
                  :account_details

    alias_method :online?, :online

    def commission_percentage
      return 0 if commission <= 0
      commission / COMMISSION_PERCENTAGE_FACTOR
    end
  end
end
