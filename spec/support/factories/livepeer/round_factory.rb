FactoryBot.define do
  factory :livepeer_round, class: 'Livepeer::Round' do
    chain { create(:livepeer_chain) }

    sequence(:number, 1000)
    initialized_at { 1.day.ago }
    mintable_tokens { rand(10_000_000..20_000_000) }
  end
end
