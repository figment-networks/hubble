require 'features_helper'

feature 'cosmos validators' do
  let!(:chain) { create(:cosmos_chain) }
  let!(:validators) { create(:cosmos_validator_synced, chain: chain) }
  let!(:account) { create(:cosmos_account, chain: chain, validator_id: validators.id) }
  let!(:proposals) { create(:cosmos_governance_proposal, chain: chain) }

  before do
    create(:cosmos_block, chain: chain, proposer_address: validators.address)
    create(:cosmos_block_2, chain: chain)
    create(:cosmos_block_3, chain: chain )
    allow(chain).to receive(:governance_params_synced?).and_return(true)
    allow(proposals).to receive(:valid_proposal?).and_return(true)
  end


  context 'logged out' do
    scenario 'visiting Cosmos Validators View as not signed in user', :vcr do
      visit "/cosmos/chains/#{chain.slug}/validators/#{validators.address}"
      expect(page).to have_content("Cosmos")
      expect(page).to have_content(validators.moniker)
      expect(page).to have_content("Visit Site")
      expect(page).to have_content(validators.address)
      expect(page).to have_content(account.address)
      expect(page).to have_content("Stake Now")
      expect(page).to have_content("With your Ledger Nano S\non Brave, Chrome, or Opera.")
      expect(page).to have_content("Waiting for first sync...")
      expect(page).to have_content("Uptime History")
      expect(page).to have_content("Last 48 Hours")
      expect(page).to have_content("100")
      expect(page).to have_content("Governance Proposal Activity")
      expect(page).to have_content("No governance proposal activity yet.")
      expect(page).to have_content("Event History")
      expect(page).to have_content("most recent 20")
      expect(page).to have_content("Subscribe")
      expect(page).to have_content("Delegations")
      expect(page).to have_content("Current Voting Power")
      expect(page).to have_content("ATOM")
      expect(page).to have_content("Proposal Probability 100%")
      expect(page).to have_content("Commission")
      expect(page).to have_content("Blocks")
      expect(page).to have_content("Lifetime")
      expect(page).to have_content("UTC")
    end
  end
end
