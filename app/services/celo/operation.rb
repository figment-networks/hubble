module Celo
  class Operation < Common::Resource
    TRANSFER_TYPE = 'transfer'.freeze

    field :success
    field :type
    field :from
    field :to
    field :transaction_hash
    field :height, type: :integer
    field :kind
    field :value, type: :integer
    field :details

    alias amount value

    def transfer?
      type == TRANSFER_TYPE
    end
  end
end
