FactoryBot.define do
  factory :livepeer_orchestrator, class: 'Livepeer::Orchestrator' do
    chain { create(:livepeer_chain) }

    address { '0xc22bc16573b4a9844499cdb01b3b07268a82299b' }
    active { true }
    reward_cut { 40 }
    fee_share { 80 }
    total_stake { 1_000_000 }
  end
end
