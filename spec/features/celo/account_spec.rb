require 'features_helper'

describe 'celo account details' do
  let(:chain) { create(:celo_chain) }
  let(:address) { '0x456f41406B32c45D59E539e4BBA3D7898c3584dA' }

  it 'visiting as not signed in user', :vcr do
    visit "/celo/chains/#{chain.slug}/accounts/#{address}"

    expect(page).to have_content('0x456f41406B32c45D59E539e4BBA3D7898c3584dA')
    expect(page).to have_content('Figment')
    expect(page).to have_content('GOLD BALANCE')
    expect(page).to have_content('TOTAL LOCKED GOLD')
    expect(page).to have_content('Transfers')
    expect(page).to have_content('Transactions')
    expect(page).to have_content('InternalTransferSent')
    expect(page).to have_content('ValidatorGroupVoteCastReceived')
  end
end
