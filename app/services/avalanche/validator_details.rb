module Avalanche
  class ValidatorDetails < Common::Resource
    field :validator, type: Avalanche::Validator
    field :delegations, type: Avalanche::Delegation

    collection :delegations, type: Avalanche::Delegation
    collection :stats_24h, type: Avalanche::ValidatorStat
  end
end
