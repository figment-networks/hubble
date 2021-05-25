require 'features_helper'

describe 'skale account details' do
  let(:chain) { create(:skale_chain) }
  let(:account) { '0x004302ff315df99e7a200d3f21bf5b85f747dae9' }

  it 'visiting account details', :vcr do
    visit "/skale/chains/#{chain.slug}/accounts/#{account}"
    expect(page).to have_content('ACCOUNT ADDRESS - DELEGATOR')
    expect(page).to have_content(account)
    expect(page).to have_content('DELEGATION INFO')
  end
end
