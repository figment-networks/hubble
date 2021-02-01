module Mina
  class ValidatorDetails < Common::Resource
    field :validator, type: Mina::Validator
    field :account, type: Mina::Account

    collection :delegations, type: Mina::Account
    collection :stats, type: Mina::ValidatorStat
  end
end
