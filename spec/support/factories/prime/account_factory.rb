FactoryBot.define do
  factory :prime_account, class: 'Prime::Account' do
    address { '14EARDJPoMytBe355sRmtq2pJD99n4rZqAnc2bfkWyrPn1J6' }
    type { 'Prime::Accounts::Polkadot' }
    user
    network factory: :prime_network
  end
end
