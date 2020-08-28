FactoryBot.define do
  factory :livepeer_delegator, class: Livepeer::Delegator do
    chain { create(:livepeer_chain) }

    address { '0x1a185035151253f83a7c6775dd56d4a7b00e7779' }
  end
end
