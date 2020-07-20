FactoryBot.define do
  factory :livepeer_stake, class: Livepeer::Stake do
    round { create(:round) }

    delegator_address { '0xcb31d90803f50bc5915925fe40d97cc6b71f0e04' }
    pending_stake { 200 }
    unclaimed_stake { 100 }
  end
end
