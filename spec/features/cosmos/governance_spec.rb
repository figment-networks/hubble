require 'features_helper'

describe 'cosmos validators' do
  let!(:chain) { create(:cosmos_chain) }
  let!(:proposal) { create(:cosmos_governance_proposal, chain: chain) }

  context 'logged out' do
    it 'visiting Cosmos Governance View as not signed in user' do
      visit "/cosmos/chains/#{chain.slug}/governance/proposals/#{proposal.ext_id}"

      expect(page).to have_content(chain.name)
      expect(page).to have_content(proposal.title)
      expect(page).to have_content('33.4%')
      expect(page).to have_content('See the full proposal here: ipfs.io')
    end
  end
end
