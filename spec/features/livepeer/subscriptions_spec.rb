require 'features_helper'

feature 'Livepeer Subscriptions' do
  let!(:user) { create(:user) }
  let!(:chain) { create(:livepeer_chain) }

  let!(:delegator_list) { create(:livepeer_delegator_list, user: user, chain: chain) }

  context 'as a signed in user', :vcr do
    before { log_in(user) }

    scenario 'subscribing to a delegator list' do
      visit "/livepeer/chains/#{chain.slug}/delegator_lists"

      expect(page).to have_content(delegator_list.name)
      expect(page).to have_content('NOT SUBSCRIBED')

      find('a .fa-bell').click

      expect(page).to have_content('Subscribe to Events')
      expect(page).to have_content("Delegator List #{delegator_list.name}")

      choose 'alert_subscription[event_kinds][reward_cut_change]', option: 'on'
      choose 'alert_subscription[wants_daily_digest]', option: 'on'

      click_button 'save subscription'

      expect(page).to have_content('Subscribed to events for this delegator list.')

      click_link 'back'

      expect(page).to have_content(delegator_list.name)
      expect(page).to have_content('SUBSCRIBED')
    end

    context 'with an existing alert subscription' do
      before do
        create(:livepeer_alert_subscription, user: user, alertable: delegator_list)
      end

      scenario 'unsubscribing from a delegator list' do
        visit "/livepeer/chains/#{chain.slug}/delegator_lists"

        find('a .fa-bell').click

        expect(page).to have_content('Subscribe to Events')
        expect(page).to have_content("Delegator List #{delegator_list.name}")

        choose 'alert_subscription[event_kinds][reward_cut_change]', option: 'off'

        click_button 'save subscription'

        expect(page).to have_content('No alerts selected. Subscription removed.')

        click_link 'back'

        expect(page).to have_content(delegator_list.name)
        expect(page).to have_content('NOT SUBSCRIBED')
      end
    end
  end
end
