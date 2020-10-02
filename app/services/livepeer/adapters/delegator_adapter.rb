class Livepeer::Adapters::DelegatorAdapter < Livepeer::Adapters::BaseAdapter
  attribute :orchestrator_address
  attribute :pending_stake

  def orchestrator_address
    data.delegate.id
  end

  def pending_stake
    convert_lpt_amount(data.pending_stake)
  end
end
