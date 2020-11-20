module Polkadot
  class Transfer < Common::Resource
    field :transaction_hash
    field :participant
    field :height, type: :integer
    field :amount, type: :integer
    field :kind
  end
end
