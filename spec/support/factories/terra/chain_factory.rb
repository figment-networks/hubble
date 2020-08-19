FactoryBot.define do
  factory :terra_chain, class: Terra::Chain do
    name { "TerraChain" }
    sequence(:slug) { |n| "terra-#{n}"}
    disabled { false }
    testnet { false }
  end
end
