FactoryBot.define do
  factory :livepeer_share, class: Livepeer::Share do
    pool { create(:livepeer_pool) }

    delegator_address { '0xcb31d90803f50bc5915925fe40d97cc6b71f0e04' }
    fees { 10 }
    reward_tokens { 100 }
  end
end
