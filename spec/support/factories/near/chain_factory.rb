FactoryBot.define do
  factory :near_chain, class: Near::Chain do
    name { "NearChain" }
    slug { "nearslug"}
    api_url { "https://12.345.678.910/near" }
    testnet { false }
    disabled { false }
  end
end
