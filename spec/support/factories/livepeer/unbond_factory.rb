FactoryBot.define do
  factory :livepeer_unbond, class: Livepeer::Unbond do
    round { create(:livepeer_round) }

    transaction_hash { 'ae038d03a0f37de7ece9b47c2df37c1d5328d6d75cb01e35c7d3c8df9915b3cb' }
    delegator_address { '0xb1e3981a5be68930161e3e4b327c8a528b92515a' }
    transcoder_address { '0xd44e364f985ceaae31e5d7b5782d5822a89db41d' }
    amount { rand(1000) }
    initialized_at { 20.minutes.ago }
    withdraw_round_number { round.number + 7 }
    sequence(:unbonding_lock_id, 10)
  end
end
