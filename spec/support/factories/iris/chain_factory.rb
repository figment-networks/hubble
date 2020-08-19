FactoryBot.define do
  factory :iris_chain, class: Iris::Chain do
    name { "IrisChain" }
    sequence(:slug) { |n| "iris-#{n}"}
    disabled { false }
    testnet { false }
  end
end

