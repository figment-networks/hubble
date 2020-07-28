require 'features_helper'

feature 'transaction details' do
  let(:chain) { create(:polkadot_chain) }
  let(:transaction_id) { 'example' }
  let(:block_id) { 2870442 }

  scenario 'visiting as not signed in user', :vcr do
    visit "/polkadot/chains/#{chain.slug}/blocks/#{block_id}/transactions/#{transaction_id}"

    expect(page).to have_content("Polkadot")
    expect(page).to have_content(block_id)
  end
end
