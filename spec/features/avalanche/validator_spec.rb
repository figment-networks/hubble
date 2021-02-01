require 'features_helper'

describe 'avalanche validator details' do
  let(:chain) { create(:avalanche_chain) }
  let(:address) { 'NodeID-EiLtFTxRYttP5EcHc9Ap6SBQvaXkbUKxT' }

  it 'visiting validator details', :vcr do
    visit "/avalanche/chains/#{chain.slug}/validators/#{address}"
    expect(page).to have_content('Staking Balance')
    expect(page).to have_content('Beneficiary')
    expect(page).to have_content('Delegation Fee')
    expect(page).to have_content('P-avax1u2u3m4xgtts7z9u64uckq6gxgh8pgdkhwt9a64')
    expect(page).to have_content('6,156.151 AVAX')
  end
end
