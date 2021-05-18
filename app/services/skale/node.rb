module Skale
  class Node < Common::Resource
    field :id
    field :name, type: :string
    field :public_ip
    field :start_block, type: :integer
    field :last_reward_date, type: :timestamp
    field :next_reward_date, type: :timestamp
    field :validator_id, type: :integer
    field :status, type: :string
    field :address, type: :string
  end
end
