class Livepeer::Adapters::BondAdapter < Livepeer::Adapters::TransactionAdapter
  attribute :old_orchestrator_address

  def orchestrator_address
    data.new_delegate.id
  end

  def old_orchestrator_address
    data.old_delegate&.id
  end

  def amount
    convert_lpt_amount(data.additional_amount)
  end
end
