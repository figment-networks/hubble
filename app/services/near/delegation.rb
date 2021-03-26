module Near
  class Delegation < Common::Resource
    field :account
    field :unstaked_balance, type: :integer
    field :staked_balance, type: :integer
    field :can_withdraw
  end
end
