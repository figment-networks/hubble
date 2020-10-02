class Livepeer::Delegator < ApplicationRecord
  belongs_to :chain

  def orchestrator
    chain.orchestrators.find_by(address: orchestrator_address)
  end

  def stake_share
    return if pending_stake.nil?
    return if orchestrator&.total_stake.nil?

    pending_stake / orchestrator.total_stake * 100
  end
end
