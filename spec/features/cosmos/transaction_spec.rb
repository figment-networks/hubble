require 'features_helper'

describe 'Cosmos transaction details' do
  let(:chain) { create(:cosmos_chain) }
  let(:transaction_id) { 'F6D60625517A8B152CD430EE2F478E611DD41D72F2A55E7F2C4958C83BB94838' }
  let(:block_id) { 3651470 }

  it 'visiting Transaction View as not signed in user', :vcr do
    visit "/cosmos/chains/#{chain.slug}/blocks/#{block_id}/transactions/#{transaction_id}"
    expect(page).to have_content(chain.name)
    expect(page).to have_content(block_id)
    expect(page).to have_content('cosmos1hvsdf03tl6w5pnfvfv5g8uphjd4wfw2hsucxnd')
    expect(page).to have_content('200,000 GAS')
    expect(page).to have_content('106,019 GAS')
  end
end
