module Oasis
  class Transaction < Common::Resource
    field :public_key
    field :hash
    field :nonce
    field :fee
    field :gas_limit
    field :gas_price
    field :method
  end
end
