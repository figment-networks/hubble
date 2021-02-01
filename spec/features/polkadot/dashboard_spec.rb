require 'features_helper'

describe 'polkadot dashboard' do
  let!(:chain) { create(:polkadot_chain) }
  let!(:alertable) { create(:alertable_address, chain: chain, address: '153RWxqZyAWBM2brLkBEkYmyVyf5aMqGHewbvG3jqENyCKyC') }
  let!(:user) { create(:user) }
  let!(:alert_subscription) do
    create(:alert_subscription,
           user: user,
           alertable: alertable)
  end

  context 'logged out' do
    it 'visiting Polkadot Dashboard View as not signed in user', :vcr do
      visit_chain_dashboard_page
      expect(page).to have_content('Login')
    end
  end

  context 'logged in' do
    it 'visiting Polkadot Dashboard View as signed in user', :vcr do
      log_in(user)

      visit_chain_dashboard_page

      expect(page).to have_content("Dashboard for #{chain.name}")
      expect(page).to have_content('Last notified')
      expect(page).to have_content("Voting Power Change (+/-#{alert_subscription.data['percent_change']}")
    end
  end
end
