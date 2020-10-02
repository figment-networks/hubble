FactoryBot.define do
  factory :livepeer_event, class: 'Livepeer::Event' do
    round { create(:livepeer_round) }

    type { 'Livepeer::Events::RewardCutChange' }
    timestamp { 1.minute.ago }
    orchestrator_address { '0xa49c7603d4224aa76497ba0a19a2a931168df259' }
    data { { reward_cut: '30.0' } }
  end
end
