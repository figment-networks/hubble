FactoryBot.define do
  factory :kava_chain, class: 'Kava::Chain' do
    name { 'KavaChain' }
    sequence(:slug) { |n| "kava-#{n}" }
    disabled { false }
    testnet { false }
  end
end
