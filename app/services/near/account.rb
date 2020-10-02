module Near
  class Account < Common::Resource
    field :id
    field :name
    field :start_height
    field :start_time, type: :timestamp
    field :last_height
    field :last_time, type: :timestamp
    field :balance, type: :integer
    field :staking_balance, type: :integer
    field :created_at, type: :timestamp
    field :updated_at, type: :timestamp
  end
end
