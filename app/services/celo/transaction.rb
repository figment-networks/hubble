module Celo
  class Transaction < Common::Resource
    field :gas_price, type: :integer
    field :gas, type: :integer
    field :gas_used, type: :integer
    field :success
    field :kind
    field :hash
    field :transaction_hash
    field :amount, type: :integer
    field :height, type: :integer
    field :time, type: :timestamp
    collection :operations, type: Celo::Operation

    alias is_success success
    alias block height

    # Some endpoints return `hash`, some return `transaction_hash`...
    def hash
      @hash || @transaction_hash
    end

    def transfers
      operations.select(&:transfer?)
    end

    def other_operations
      operations.reject(&:transfer?)
    end
  end
end
