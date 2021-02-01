module Avalanche
  class Account < Common::Resource
    field :balance, type: :integer
    field :unlocked, type: :integer
    field :locked_stakeable, source: 'lockedStakeable', type: :integer
    field :locked_not_stakeable, source: 'lockedNotStakeable', type: :integer
  end
end
