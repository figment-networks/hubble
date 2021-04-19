FactoryBot.define do
  factory :near_chain, class: 'Near::Chain' do
    name { 'NearChain' }
    sequence(:slug) { |n| "near-#{n}" }
    api_url { 'http://localhost:8080' }
    testnet { false }
    disabled { false }
  end
end
