require 'features_helper'

describe 'cosmos validators' do
  let(:chain) { create(:cosmos_chain) }
  let(:validator) { create(:cosmos_validator_synced, chain: chain) }
  let(:account) { create(:cosmos_account, chain: chain, validator_id: validator.id) }
  let(:proposals) { create(:cosmos_governance_proposal, chain: chain) }

  before do
    create(:cosmos_block, chain: chain, proposer_address: validator.address)
    create(:cosmos_block_2, chain: chain)
    create(:cosmos_block_3, chain: chain)
    allow(chain).to receive(:governance_params_synced?).and_return(true)
    allow(proposals).to receive(:valid_proposal?).and_return(true)
  end

  context 'logged out' do
    it 'visiting Cosmos Validators View as not signed in user', :vcr do
      visit "/cosmos/chains/#{chain.slug}/validators/#{validator.address}"
      expect(page).to have_content(validator.address)
      expect(page).to have_content('UPTIME HISTORY')
      expect(page).to have_content('Governance Proposal Activity')
      expect(page).to have_content('Event History')
      expect(page).to have_content('Delegations')
      expect(page).to have_content('CURRENT VOTING POWER')
    end
  end
end
