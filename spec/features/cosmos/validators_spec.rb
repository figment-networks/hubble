require 'features_helper'

describe 'cosmos validators' do
  let!(:chain) { create(:cosmos_chain) }
  let!(:validators) { create(:cosmos_validator_synced, chain: chain) }
  let!(:account) { create(:cosmos_account, chain: chain, validator_id: validators.id) }
  let!(:proposals) { create(:cosmos_governance_proposal, chain: chain) }

  before do
    create(:cosmos_block, chain: chain, proposer_address: validators.address)
    create(:cosmos_block_2, chain: chain)
    create(:cosmos_block_3, chain: chain)
    allow(chain).to receive(:governance_params_synced?).and_return(true)
    allow(proposals).to receive(:valid_proposal?).and_return(true)
  end

  context 'logged out' do
    it 'visiting Cosmos Validators View as not signed in user', :vcr do
      visit "/cosmos/chains/#{chain.slug}/validators/#{validators.address}"
      expect(page).to have_content(validators.moniker)
      expect(page).to have_content(validators.address)
      expect(page).to have_content(account.address)
      expect(page).to have_content('Waiting for first sync...')
      expect(page).to have_content('UPTIME HISTORY')
      expect(page).to have_content('Last 48 Hours')
      expect(page).to have_content('100')
      expect(page).to have_content('Governance Proposal Activity')
      expect(page).to have_content('No governance proposal activity yet.')
      expect(page).to have_content('Event History')
      expect(page).to have_content('Subscribe')
      expect(page).to have_no_content('Delegations')
      expect(page).to have_content('CURRENT VOTING POWER')
      expect(page).to have_content('ATOM')
      expect(page).to have_content('Proposal Probability')
      expect(page).to have_content('COMMISSION')
      expect(page).to have_content('BLOCKS')
      expect(page).to have_content('LIFETIME')
      expect(page).to have_content('UTC')
    end
  end
end
