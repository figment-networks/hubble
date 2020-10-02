module Near
  class Block < Common::Resource
    field :id
    field :app_version
    field :height
    field :time, type: :timestamp
    field :producer
    field :hash
    field :prev_hash
    field :epoch
    field :gas_price
    field :gas_allowed
    field :gas_used
    field :rent_paid
    field :validator_reward
    field :total_supply
    field :signature
    field :chunks_count
    field :transactions_count
    field :created_at, type: :timestamp
    field :updated_at, type: :timestamp
  end
end
