require 'features_helper'

describe 'Cosmos transaction details' do
  let(:chain) { create(:cosmos_chain) }
  let(:transaction_id) { '746B3C5F4A14BA32F18733E8866F3CC1B1CAB8061480AEBCDC9EF45E32D87297' }
  let(:block_id) { 2770076 }

  it 'visiting Transaction View as not signed in user', :vcr do
    visit "/cosmos/chains/#{chain.slug}/blocks/#{block_id}/transactions/#{transaction_id}"

    expect(page).to have_content(chain.name)
    expect(page).to have_content(block_id)
    expect(page).to have_content('cosmos1dsq6e9gppnr3u46jhrjgv5vs30z3gqdakdp54t')
    expect(page).to have_content('cosmos1fhr7e04ct0zslmkzqt9smakg3sxrdve6etv27e')
    expect(page).to have_content('82,942 GAS')
    expect(page).to have_content('0.003 ATOM')
  end
end
