class Livepeer::Orchestrator < ApplicationRecord
  belongs_to :chain

  scope :active, -> { where(active: true) }

  def to_param
    address
  end

  def name_or_address
    name || address.sub(/^0x/i, '').upcase
  end

  def delegators
    chain.delegators.where(orchestrator_address: address)
  end

  def events
    chain.events.where(orchestrator_address: address)
  end
end
