module Skale
  class DelegationSummary < Common::Resource
    field :amount, type: :integer
    field :state, type: :string
  end
end
