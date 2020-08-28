require 'features_helper'

def visit_validator_page(chain_slug, validator_id)
  visit "/oasis/chains/#{chain_slug}/validators/#{validator_id}"
end

feature 'oasis validators' do
  let!(:chain) { create(:oasis_chain, api_url: 'https://localhost:1111') }
  let(:validator_id) { 'oasis1qr5nk5zd79edhu67lpwfhkamcgnavfuujyy690qq' }
  let(:user) { create(:user) }

  context 'logged out' do
    scenario 'visiting Oasis Validators View as not signed in user', :vcr do
      visit_validator_page(chain.slug, validator_id)

      expect(page).to have_content("Oasis")
      expect(page).to have_content(validator_id)
      expect(page).to have_content("Entity ID")
      expect(page).to have_content("Voting Power History")
      expect(page).to have_content("Current Voting Power")
      expect(page).to have_content("Blocks")
      expect(page).to have_content("Lifetime")
      expect(page).to have_content("Uptime History")

    end
  end
  # Skip while events section is hidden #

  # context 'logged in' do
  #   scenario 'visiting Oasis Validators View as signed in user', :vcr do
  #     log_in(user)

  #     visit_validator_page(chain.slug, validator_id)
  #     expect(page).to have_content("Subscribe to Alerts")
  #   end
  # end
end
