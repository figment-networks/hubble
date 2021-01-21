require 'features_helper'

describe 'tezos dashboard' do
  let!(:chain) { create(:tezos_chain, slug: 'mainnet') }
  let!(:alertable) { create(:alertable_address, chain: chain, address: 'tz1PWCDnz783NNGGQjEFFsHtrcK5yBW4E2rm') }
  let!(:user) { create(:user) }
  let!(:alert_subscription) do
    create(:alert_subscription,
           user: user,
           alertable: alertable)
  end

  context 'logged out' do
    it 'visiting Tezos Dashboard View as not signed in user', :vcr do
      visit 'tezos/dashboard'
      expect(page).to have_content('Login')
    end
  end

  context 'logged in' do
    it 'visiting Tezos Dashboard View as signed in user', :vcr do
      log_in(user)
      visit 'tezos/dashboard'

      expect(page).to have_content("Dashboard for #{chain.name}")
      expect(page).to have_content('Last notified')
    end
  end
end
