FactoryBot.define do
  factory :livepeer_rebond, class: 'Livepeer::Rebond' do
    round { create(:livepeer_round) }

    transaction_hash { 'faa4afe0ce98568c8970fd194e02bf84912218620658aa27b0263cf7c100d91d' }
    delegator_address { '0x3f9d95bdea2acac5da6e5215875ada4e6268a4ea' }
    orchestrator_address { '0x836296fa79f8c1f2584974969387c11402c46791' }
    amount { rand(1000) }
    initialized_at { 20.minutes.ago }
    sequence(:unbonding_lock_id, 10)
  end
end
