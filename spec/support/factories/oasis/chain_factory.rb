FactoryBot.define do
  factory :oasis_chain, class: 'Oasis::Chain' do
    name { 'OasisChain' }
    sequence(:slug) { |n| "oasis-#{n}" }
    api_url { 'https://12.345.678.910/oasis' }
    primary { false }
    testnet { false }
    disabled { false }
    token_map { { 'noasis' => { 'factor' => 9, 'display' => 'OASIS', 'primary' => true } } }
  end
end
