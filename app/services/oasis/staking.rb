module Oasis
  class Staking < Common::Resource
    attr_accessor :total_supply,
                  :common_pool,
                  :debonding_interval,
                  :min_delegation_amount

  end
end
