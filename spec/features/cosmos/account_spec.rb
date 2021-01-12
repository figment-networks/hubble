require 'features_helper'

describe 'cosmos account' do
  let!(:chain) { create(:cosmos_chain) }
  let!(:account) { create(:cosmos_account, chain: chain, address: 'cosmos1hjct6q7npsspsg3dgvzk3sdf89spmlpfg8wwf7') }

  context 'logged out' do
    it 'visiting Cosmos Account View as not signed in user', :vcr do
      visit "/cosmos/chains/#{chain.slug}/accounts/#{account.address}"

      expect(page).to have_content(chain.name)
      expect(page).to have_content(account.address)
      expect(page).to have_content('BALANCE')
      expect(page).to have_content('DELEGATION')
      expect(page).to have_content('PENDING REWARDS')
      expect(page).to have_content('Delegations')
      expect(page).to have_content('Recent Delegation Transactions')
    end
  end
end
