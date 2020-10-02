class Livepeer::Adapters::UnbondAdapter < Livepeer::Adapters::TransactionAdapter
  attribute :withdraw_round_number
  attribute :unbonding_lock_id

  def withdraw_round_number
    data.withdraw_round
  end
end
