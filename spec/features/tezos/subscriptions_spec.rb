require 'features_helper'

describe 'Tezos Subscriptions' do
  let!(:user) { create(:user) }
  let!(:chain) { create(:tezos_chain) }
  let(:baker_id) { 'tz2Q7Km98GPzV1JLNpkrQrSo5YUhPfDp6LmA' }

  context 'as a signed in user', :vcr do
    before { log_in(user) }

    it 'subscribing to a baker' do
      visit tezos_baker_path(baker_id)

      expect(page).to have_content(baker_id)
      expect(page).to have_content('Subscribe')

      click_link('Subscribe')

      expect(page).to have_content('Subscribe to Events')

      expect(page).to have_content('Missed Bake')
      expect(page).to have_content('Steal')
      expect(page).to have_content('Missed Endorsement')
      expect(page).to have_content('Double Bake')
      expect(page).to have_content('Double Endorsement')
      expect(page).to have_content('Baker Activated')
      expect(page).to have_content('Baker Deactivated')
      expect(page).to have_content('Balance Change %')

      choose 'alert_subscription[event_kinds][missed_bake]', option: 'on'
      choose 'alert_subscription[event_kinds][steal]', option: 'on'
      choose 'alert_subscription[event_kinds][balance_change]', option: 'on'
      fill_in 'alert_subscription[data][percent_change]', with: 5

      click_button 'save subscription'

      expect(page).to have_content('Subscribed to events for this Baker!')

      click_link 'back'

      expect(page).to have_content(baker_id)
      expect(page).to have_content('Subscribed')
      user.reload
      expect(user.tezos_subscriptions_count).not_to eq 0
      expect(User.with_subscriptions('Tezos')).to include(user)

      alertable = AlertableAddress.find_by(address: baker_id)
      sub = AlertSubscription.find_by(user: user, alertable: alertable)
      expect(sub.event_kinds).to include('balance_change')
      expect(sub.data['percent_change']).to eq(5.0)
    end

    context 'with an existing alert subscription' do
      before { log_in(user) }

      let!(:alertable_address) { create(:alertable_address, chain: chain, address: baker_id) }
      let!(:alert_subscription) { create(:alert_subscription, user: user, alertable: alertable_address, event_kinds: ['missed_bake'], wants_daily_digest: false) }

      it 'unsubscribes from a baker' do
        visit tezos_baker_path(baker_id)

        expect(page).to have_content('Subscribed')

        click_link 'Subscribed'

        choose 'alert_subscription[event_kinds][missed_bake]', option: 'off'
        click_button 'save subscription'

        expect(page).to have_content('No alerts selected. Subscription removed.')
      end
    end
  end
end
