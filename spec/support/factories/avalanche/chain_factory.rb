FactoryBot.define do
  factory :avalanche_chain, class: 'Avalanche::Chain' do
    name { 'Mainnet' }
    sequence(:slug) { |n| "avalanche-#{n}" }
    api_url { 'http://localhost:5252' }
    testnet { false }
    disabled { false }
    primary { false }
  end
end
