FactoryBot.define do
  factory :cosmos_chain, class: Cosmos::Chain do
    name { "CosmosChain" }
    slug { "cosmos-slug"}
    disabled { false }
    testnet { false }
  end
end
