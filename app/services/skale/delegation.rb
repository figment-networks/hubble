module Skale
  class Delegation < Common::Resource
    field :id
    field :holder
    field :transaction_hash
    field :validator_id
    field :block_height
    field :amount, type: :integer
    field :period
    field :validator_name
    field :created, type: :timestamp
    field :started
    field :finished
    field :info
    field :state

    def open_delegation
      @state == 'DELEGATED' || @state == 'UNDELEGATION_REQUESTED'
    end
  end
end
