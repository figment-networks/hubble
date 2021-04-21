FactoryBot.define do
  factory :skale_chain, class: 'Skale::Chain' do
    name { 'SkaleChain' }
    sequence(:slug) { |n| "skale-#{n}" }
    api_url { 'https://localhost:8080' }
    testnet { false }
    disabled { false }
  end
end
