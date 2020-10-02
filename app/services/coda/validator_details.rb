module Coda
  class ValidatorDetails < Resource
    field :validator, type: Coda::Validator
    field :account,   type: Coda::Account

    collection :delegations, type: Coda::Account
    collection :stats,       type: Coda::ValidatorStat
  end
end
