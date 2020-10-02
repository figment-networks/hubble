class Livepeer::Event < ApplicationRecord
  belongs_to :round

  def kind_string
    self.class.name.demodulize.underscore
  end

  def to_partial_path
    self.class.name.underscore
  end

  def positive?
    raise NotImplementedError
  end

  def icon_name
    raise NotImplementedError
  end

  def orchestrator
    round.chain.orchestrators.find_by(address: orchestrator_address)
  end
end

require_dependency 'livepeer/events/reward_cut_change'
require_dependency 'livepeer/events/missed_reward_call'
require_dependency 'livepeer/events/deactivation'
require_dependency 'livepeer/events/slashing'
