FactoryBot.define do
  factory :polkadot_chain, class: 'Polkadot::Chain' do
    name { 'Mainnet' }
    sequence(:slug) { |n| "polkadot-#{n}" }
    api_url { 'http://localhost:8081' }
    testnet { false }
    disabled { false }
    primary { false }
  end
end
