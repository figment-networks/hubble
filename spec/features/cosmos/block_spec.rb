require 'features_helper'

feature 'Cosmos block details' do
  let(:chain) { create(:cosmos_chain) }
  let!(:block) { create(:cosmos_block, chain: chain, height: 2636453) }
  let!(:validators) { [ create(:cosmos_validator_synced, chain: chain, latest_block_height: 2636453) ] }

  before do
    allow(chain).to receive(:active_validators_at_height).and_return(validators)
  end

  scenario 'visiting as not signed in user', :vcr do
    visit "/cosmos/chains/#{chain.slug}/blocks/#{block.height}"
    expect(page).to have_content(chain.network_name)
    expect(page).to have_content(block.height)
    expect(page).to have_content(block.id_hash)
    expect(page).to have_content(validators[0].moniker)

  end
end
