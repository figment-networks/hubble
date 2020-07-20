require 'features_helper'

feature 'oasis validators' do
  let!(:chain) { create(:oasis_chain, api_url: 'https://localhost:1111') }
  let(:validator_id) { 'oasis1qr5nk5zd79edhu67lpwfhkamcgnavfuujyy690qq' }

  context 'logged out' do
    scenario 'visiting Oasis Validators View as not signed in user', :vcr do
      visit "/oasis/chains/#{chain.slug}/validators/#{validator_id}.1"

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
  context 'logged in' do
    # to be further scoped out when logged in features become available
  end
end
