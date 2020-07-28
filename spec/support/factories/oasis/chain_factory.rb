FactoryBot.define do
  factory :oasis_chain, class: Oasis::Chain do
    name { "OasisChain" }
    sequence(:slug) { |n| "oasis-#{n}" }
    api_url { "https://12.345.678.910/oasis" }
    primary { false }
    testnet { false }
    disabled { false }
  end
end
