FactoryBot.define do
  factory :livepeer_delegator_list, class: Livepeer::DelegatorList do
    user { create(:user) }
    chain { create(:livepeer_chain) }

    sequence(:name) { |n| "Delegator List #{n}" }
    addresses { %w{0xcb31d90803f50bc5915925fe40d97cc6b71f0e04} }
  end
end
