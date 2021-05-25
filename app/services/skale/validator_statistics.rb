module Skale
  class ValidatorStatistics < Common::Resource
    field :amount, type: :integer
    field :block_time, type: :timestamp
  end
end
