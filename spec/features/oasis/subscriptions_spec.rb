require 'features_helper'

def visit_validator_subscription_page(chain_slug, validator_id)
  visit "/oasis/chains/#{chain_slug}/validators/#{validator_id}/subscriptions"
end

feature 'oasis subscriptions' do
  let!(:chain) { create(:oasis_chain, api_url: 'https://localhost:1111') }
  let!(:alertable) { create(:alertable_address, chain: chain) }
  let!(:user) { create(:user) }
  let!(:alert_subscription) { create(:alert_subscription,
                                user: user,
                                alertable: alertable)}

  context 'logged out' do
    scenario 'visiting Oasis Validators Subscriptions View as not signed in user', :vcr do
      visit_validator_subscription_page(chain.slug, alertable.address)
      expect(page).to have_content("Login")
    end
  end

  context 'logged in' do

    scenario 'visiting Oasis Validators Subscriptions View as signed in user', :vcr do
      log_in(user)

      visit_validator_subscription_page(chain.slug, alertable.address)

      expect(page).to have_content("Voting Power Change %")
      expect(page).to have_content("Misses N of Last M Precommits")
      expect(page).to have_content("Receive Daily Digest?")

    end

  end
end
