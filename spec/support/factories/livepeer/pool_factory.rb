FactoryBot.define do
  factory :livepeer_pool, class: Livepeer::Pool do
    round { create(:livepeer_round) }

    transcoder_address { '0x3d0796ee948a30425c77697910455b56ea27be54' }
    total_stake { 1_000_000 }
    fees { 100 }
    reward_tokens { 1000 }
  end
end
