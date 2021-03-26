FactoryBot.define do
  factory :prime_chain, class: 'Prime::Chain' do
    sequence(:name) { |n| "ChainName-#{n}" }
    type { 'Prime::Chains::Polkadot' }
    sequence(:slug) { |n| "polkadot-#{n}" }
    api_url { 'http://localhost:2222' }
    primary { true }
    active { true }
    figment_validator_addresses { ['138QdRbUTB9eNY94Q4Mj5r39FkgMiyHCAy8UFMNA5gvtrfSB'] }
    reward_token_remote { 'polkadot' }
    reward_token_display { 'DOT' }
    reward_token_factor { 10 }
    network factory: :prime_network
  end
end
