FactoryBot.define do
  factory :livepeer_bond, class: Livepeer::Bond do
    round { create(:livepeer_round) }

    transaction_hash { 'f21dea74d898cfeaf836ecc99ad0331bade09711ff927365e91ada2ff4cb5caf' }
    delegator_address { '0xfce1261f66c88c4571b875af0cf7d9415fe0ff0f' }
    transcoder_address { '0xfea3d6abfc3e7d96922218e9da2c38dc69760038' }
    old_transcoder_address { '0xd6fac581e9e022930b2160c1254a696dc004c6d1' }
    amount { rand(1000) }
    initialized_at { 20.minutes.ago }
  end
end
