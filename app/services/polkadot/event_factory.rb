module Polkadot
  class EventFactory
    EVENT_KIND_CLASSES = {
      'joined_set' => 'Common::Event::ActiveSetInclusion',
      'left_set' => 'Common::Event::ActiveSetInclusion',
      'active_balance_change_1' => 'Common::Event::VotingPowerChange',
      'active_balance_change_2' => 'Common::Event::VotingPowerChange',
      'active_balance_change_3' => 'Common::Event::VotingPowerChange',
      'delegation_joined' => 'Common::Event::DelegationChange',
      'delegation_left' => 'Common::Event::DelegationChange',
      'missed_n_consecutive' => 'Common::Event::NConsecutive',
      'missed_n_of_m' => 'Common::Event::NOfM',
      'commission_change_1' => 'Common::Event::RewardCutChange',
      'commission_change_2' => 'Common::Event::RewardCutChange',
      'commission_change_3' => 'Common::Event::RewardCutChange'
    }.freeze

    def self.generate(attrs, chain)
      if attrs['data']
        attrs['data'].merge({ 'actor' => attrs['actor'] })
      else
        attrs['data'] = { 'actor' => attrs['actor'] }
      end
      EVENT_KIND_CLASSES[attrs['kind']].constantize.new(attrs, chain)
    end
  end
end
