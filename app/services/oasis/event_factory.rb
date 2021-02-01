module Oasis
  class EventFactory
    EVENT_KIND_CLASSES = {
      joined_active_set: Common::Event::ActiveSetInclusion,
      left_active_set: Common::Event::ActiveSetInclusion,
      active_escrow_balance_change_1: Common::Event::VotingPowerChange,
      active_escrow_balance_change_2: Common::Event::VotingPowerChange,
      active_escrow_balance_change_3: Common::Event::VotingPowerChange,
      missed_n_consecutive: Common::Event::NConsecutive,
      missed_n_of_m: Common::Event::NOfM,
      commission_change_1: Common::Event::RewardCutChange,
      commission_change_2: Common::Event::RewardCutChange,
      commission_change_3: Common::Event::RewardCutChange
    }.with_indifferent_access.freeze

    def self.generate(attrs, chain)
      EVENT_KIND_CLASSES[attrs['kind']].new(attrs, chain)
    end
  end
end
