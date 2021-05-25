require 'features_helper'

describe 'skale accounts page' do
  let(:chain) { create(:skale_chain) }

  it 'visiting accounts', :vcr do
    visit "/skale/chains/#{chain.slug}/accounts"
    expect(page).to have_content('Accounts')
    expect(page).to have_content('Delegator')
    expect(page).to have_content('0x004302ff315df99e7a200d3f21bf5b85f747dae9')
  end
end
