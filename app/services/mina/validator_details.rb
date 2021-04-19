module Mina
  class ValidatorDetails < Common::Resource
    field :validator, type: Mina::Validator
    field :account, type: Mina::Account

    collection :delegations, type: Mina::Account
    collection :stats_daily, type: Mina::ValidatorStat
    collection :stats_hourly, type: Mina::ValidatorStat
  end
end
