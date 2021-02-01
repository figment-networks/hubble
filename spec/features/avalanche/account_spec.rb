require 'features_helper'

describe 'avalanche account details' do
  let(:chain) { create(:avalanche_chain) }
  let(:address) { 'P-avax1m7el5kqkd00y9p594gr35l659jekm6wgxgtgcw' }

  it 'visiting account details', :vcr do
    visit "/avalanche/chains/#{chain.slug}/accounts/#{address}"
    expect(page).to have_content('ACCOUNT INFORMATION')
    expect(page).to have_content('Balance')
    expect(page).to have_content('Locked Stakeable')
    expect(page).to have_content('Beneficiary Validators')
    expect(page).to have_content('Locked Not Stakeable')
  end
end
