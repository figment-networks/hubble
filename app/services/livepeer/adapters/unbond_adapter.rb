class Livepeer::Adapters::UnbondAdapter < Livepeer::Adapters::BaseAdapter
  attribute :transaction_hash
  attribute :delegator_address
  attribute :transcoder_address
  attribute :amount
  attribute :initialized_at
  attribute :withdraw_round_number
  attribute :unbonding_lock_id

  def delegator_address
    data.delegator.id
  end

  def transcoder_address
    data.delegate.id
  end

  def amount
    convert_lpt_amount(data.amount)
  end

  def initialized_at
    convert_timestamp(data.timestamp)
  end

  def withdraw_round_number
    data.withdraw_round
  end
end
