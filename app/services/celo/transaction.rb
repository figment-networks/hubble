module Celo
  class Transaction < Common::Resource
    field :gas_price, type: :integer
    field :gas, type: :integer
    field :gas_used, type: :integer
    field :success
    field :block, type: :integer
    field :kind
    field :transaction_hash
    field :amount, type: :integer
    field :height, type: :integer
    collection :transfers, type: Celo::Transfer

    alias is_success success

    def id
      # TODO: hardcoded for now, we don't get it from Indexer yet
      '0x08613021c76fb31167e94d9c7d2ffb02cc422d7bcb89288bebab240cca28427c'
    end
  end
end
