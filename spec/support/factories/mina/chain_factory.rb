FactoryBot.define do
  factory :mina_chain, class: 'Mina::Chain' do
    name     { 'Mainnet' }
    slug     { 'mina' }
    api_url  { 'http://localhost:8081' }
    testnet  { false }
    disabled { false }
    primary  { true }
  end
end
