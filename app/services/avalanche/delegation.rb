module Avalanche
  class Delegation < Common::Resource
    field :node_id
    field :stake_amount, type: :integer
    field :potential_reward, type: :integer
    field :reward_address
    field :active_end_time, type: :timestamp
  end
end
