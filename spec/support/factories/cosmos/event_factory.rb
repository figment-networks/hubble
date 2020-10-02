FactoryBot.define do
  factory :cosmos_event, class: 'Common::ValidatorEvent' do
    type { 'Common::ValidatorEvents::ActiveSetInclusion' }
    timestamp { '2020-07-20 12:21:37.698402' }
    height { 2686237 }
    data { { 'status': 'added' } }
    created_at { '2020-07-20 12:49:46.62884' }
    updated_at { '2020-07-20 12:49:46.62884' }
    chainlike_type { 'Cosmos::Chain' }
    validatorlike_type { 'Cosmos::Validator' }
  end
end
