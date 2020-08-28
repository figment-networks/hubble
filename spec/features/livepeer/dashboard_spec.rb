require 'features_helper'

feature 'Livepeer Dashboard' do
  let!(:user) { create(:user) }
  let!(:chain) { create(:livepeer_chain) }

  let!(:delegator_list) { create(:livepeer_delegator_list, user: user, chain: chain) }

  before do
    create(:livepeer_alert_subscription, user: user, alertable: delegator_list)
  end

  scenario 'visiting the dashboard page' do
    visit "/livepeer/chains/#{chain.slug}/dashboard"

    expect(page.current_path).to eq('/login')
  end

  context 'as a signed in user', :vcr do
    before { log_in(user) }

    scenario 'visiting the dashboard page' do
      visit "/livepeer/chains/#{chain.slug}"

      click_link 'Dashboard'

      expect(page).to have_content(delegator_list.name)
      expect(page).to have_content('Last notified: Never (0 total)')
      expect(page).to have_content('Reward Cut Change')
    end
  end
end
