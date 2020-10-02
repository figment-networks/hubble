module Coda
  class TransactionStat < Resource
    field :time, type: :timestamp
    field :payments_count
    field :payments_amount
    field :delegations_count
    field :delegations_amount
    field :block_rewards_count
    field :block_rewards_amount
    field :fees_count
    field :fees_amount
    field :snark_fees_count
    field :snark_fees_amount
  end
end
