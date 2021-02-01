module Avalanche
  class NetworkStat < Common::Resource
    field :time, type: :timestamp
    field :blockchains, type: :integer
    field :peers, type: :integer
    field :active_validators, type: :integer
    field :pending_validators, type: :integer
    field :active_delegations, type: :integer
    field :pending_delegations, type: :integer
    field :total_staked, type: :integer
    field :total_delegated, type: :integer

    def total_staked_amount
      total_staked + total_delegated
    end
  end
end
