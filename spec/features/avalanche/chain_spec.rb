require 'features_helper'

describe 'avalanche validator groups' do
  let(:chain) { create(:avalanche_chain) }

  it 'visiting list of validators', :vcr do
    visit "/avalanche/chains/#{chain.slug}"

    expect(page).to have_content('Active Delegations')
    expect(page).to have_content('NODE ID')
    expect(page).to have_content('NETWORK STATISTICS')
    expect(page).to have_content('Delegated Amount')
    expect(page).to have_content('pending')
    expect(page).to have_content('Active Delegations')
  end
end
