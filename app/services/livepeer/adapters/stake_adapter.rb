class Livepeer::Adapters::StakeAdapter < Livepeer::Adapters::BaseAdapter
  attribute :delegator_address
  attribute :pending_stake
  attribute :unclaimed_stake

  def delegator_address
    data.id
  end

  def pending_stake
    convert_lpt_amount(data.pending_stake)
  end

  def unclaimed_stake
    return if pending_stake.nil? || bonded_amount.nil?

    pending_stake - bonded_amount
  end

  private

  def bonded_amount
    convert_lpt_amount(data.bonded_amount)
  end
end
