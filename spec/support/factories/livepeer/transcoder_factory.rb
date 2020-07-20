FactoryBot.define do
  factory :livepeer_transcoder, class: Livepeer::Transcoder do
    chain { create(:livepeer_chain) }

    address { '0xc22bc16573b4a9844499cdb01b3b07268a82299b' }
    active { true }
    reward_cut { 0.4 }
    fee_share { 0.8 }
    total_stake { 1_000_000 }
  end
end
