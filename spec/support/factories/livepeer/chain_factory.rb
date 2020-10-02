FactoryBot.define do
  factory :livepeer_chain, class: 'Livepeer::Chain' do
    name { 'Mainnet' }
    sequence(:slug) { |n| "livepeer-#{n}" }
    subgraph_url { 'http://subgraph_url' }
    testnet { false }
    last_sync_time { Time.current }
  end
end
