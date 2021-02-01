module Mina
  class ValidatorStat < Common::Resource
    field :time, type: :timestamp
    field :blocks_produced_count
    field :delegations_count
    field :delegations_amount
  end
end
