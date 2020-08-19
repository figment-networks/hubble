require 'features_helper'

feature 'cosmos home' do
  let!(:chain) { create(:cosmos_chain) }

  context 'logged out' do
    scenario 'visiting Cosmos Home View as not signed in user', :vcr do
      visit "cosmos/chains/#{chain.slug}"

      expect(page).to have_content(chain.name)
      expect(page).to have_content("Validators in Last Round")
      expect(page).to have_content("Round Info")
    end
  end
end
