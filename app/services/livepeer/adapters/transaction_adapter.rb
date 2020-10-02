class Livepeer::Adapters::TransactionAdapter < Livepeer::Adapters::BaseAdapter
  attribute :transaction_hash
  attribute :delegator_address
  attribute :orchestrator_address
  attribute :amount
  attribute :initialized_at

  def delegator_address
    data.delegator.id
  end

  def orchestrator_address
    data.delegate.id
  end

  def amount
    convert_lpt_amount(data.amount)
  end

  def initialized_at
    convert_timestamp(data.timestamp)
  end
end
