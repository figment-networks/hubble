FactoryBot.define do
  factory :cosmos_event, class: 'Common::ValidatorEvent' do
    chainlike { create(:cosmos_chain) }
    validatorlike { create(:cosmos_validator_synced, chain: chainlike) }

    type { 'Common::ValidatorEvents::ActiveSetInclusion' }
    timestamp { '2020-07-20 12:21:37.698402' }
    height { 2686237 }
    data { { 'status': 'added' } }
  end
end
