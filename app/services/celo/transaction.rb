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
    field :time, type: :unix_timestamp
    collection :transfers, type: Celo::Transfer

    alias is_success success
    alias block height

    # TODO: remove when real indexer returns height in all endpoints
    def height
      @height || 113
    end

    # Some endpoints return `hash`, some return `transaction_hash`...
    def hash
      @hash || @transaction_hash
    end
  end
end
