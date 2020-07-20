FactoryBot.define do
  factory :tezos_chain, class: Tezos::Chain do
    name { "TezosChain" }
    slug { "tezosslug"}
    indexer_api_base_url { "http://localhost:1738" }
    primary { false }
    disabled { false }
  end
end
