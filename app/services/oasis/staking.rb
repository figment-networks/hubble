module Oasis
  class Staking < Common::Resource
    field :total_supply
    field :common_pool
    field :debonding_interval
    field :min_delegation_amount
  end
end
