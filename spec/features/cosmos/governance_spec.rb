require 'features_helper'

describe 'cosmos validators' do
  let!(:chain) { create(:cosmos_chain) }
  let!(:proposal) { create(:cosmos_governance_proposal, chain: chain, total_deposit: [{ 'denom': 'uatom', 'amount': '51200000' }]) }
  let!(:below_threshold_proposal) { create(:cosmos_governance_proposal, ext_id: 28, title: 'Prop with < 10 percent deposits', chain: chain, total_deposit: [{ 'denom': 'uatom', 'amount': '51199999' }]) }

  context 'logged out' do
    it 'visiting Cosomos Governance Index as not signed in user' do
      visit "/cosmos/chains/#{chain.slug}/governance"

      expect(page).to have_content(chain.name)
      expect(page).to have_content(proposal.title)
      expect(page).not_to have_content(below_threshold_proposal.title)
    end

    it 'visiting Cosmos Governance View as not signed in user' do
      visit "/cosmos/chains/#{chain.slug}/governance/proposals/#{proposal.ext_id}"

      expect(page).to have_content(chain.name)
      expect(page).to have_content(proposal.title)
      expect(page).to have_content('33.4%')
      expect(page).to have_content('See the full proposal here: ipfs.io')
    end
  end
end
