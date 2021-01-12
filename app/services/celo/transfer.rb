module Celo
  class Transfer < Common::Resource
    field :success
    field :type
    field :from
    field :to
    field :transaction_hash
    field :height, type: :integer
    field :kind
    field :value, type: :integer

    alias amount value
  end
end
