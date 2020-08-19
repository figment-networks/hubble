FactoryBot.define do
  factory :cosmos_validator, class: Cosmos::Validator do
    chain { create(:oasis_chain) }

    address { "83F47D7747B0F633A6BA0DF49B7DCF61F90AA1B0" }
    current_voting_power { BigDecimal('70977.0') }
    latest_block_height { 2711879 }
    first_seen_at { '2020-07-17 07:50:34' }
    last_updated { '2020-07-22 16:01:12' }
  end
end
