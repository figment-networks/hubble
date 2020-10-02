FactoryBot.define do
  factory :livepeer_delegator, class: 'Livepeer::Delegator' do
    chain { create(:livepeer_chain) }

    address { '0x1a185035151253f83a7c6775dd56d4a7b00e7779' }
    orchestrator_address { '0xc22bc16573b4a9844499cdb01b3b07268a82299b' }
    pending_stake { 200_000 }
  end
end
