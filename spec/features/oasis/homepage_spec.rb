require 'features_helper'

feature 'oasis home' do
  let!(:chain) { create(:oasis_chain, api_url: 'https://localhost:1111') }

  context 'logged out' do
    scenario 'visiting Oasis Home View as not signed in user', :vcr do
      visit "/oasis/chains/#{chain.slug}"
      expect(page).to have_content("Oasis")
      expect(page).to have_content("Current Block")
      expect(page).to have_content("Common Pool")
      expect(page).to have_content("Voting Power")
      expect(page).to have_content("total")

    end
  end

  context 'logged in' do
    # to be further scoped out when logged in features become available
  end
end
