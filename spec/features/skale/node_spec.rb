require 'features_helper'

describe 'skale node details' do
  let(:chain) { create(:skale_chain) }
  let(:address) { '39' }

  it 'visiting node details', :vcr do
    visit "/skale/chains/#{chain.slug}/nodes/#{address}"
    expect(page).to have_content('NODE NAME')
    expect(page).to have_content('VALIDATOR')
    expect(page).to have_content('Address')
    expect(page).to have_content('April 26, 2021 at 00:02')
    expect(page).to have_content('Next Reward Date')
  end
end
