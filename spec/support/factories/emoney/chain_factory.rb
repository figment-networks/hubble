FactoryBot.define do
  factory :emoney_chain, class: 'Emoney::Chain' do
    name { 'EmoneyChain' }
    sequence(:slug) { |n| "emoney-#{n}" }
    disabled { false }
    testnet { false }
  end
end
