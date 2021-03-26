FactoryBot.define do
  factory :celo_chain, class: 'Celo::Chain' do
    name { 'Mainnet' }
    sequence(:slug) { |n| "celo-#{n}" }
    api_url { 'http://localhost:9292' }
    testnet { false }
    disabled { false }
    primary { false }
  end
end
