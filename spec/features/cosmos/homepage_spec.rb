require 'features_helper'

describe 'cosmos home' do
  let!(:chain) { create(:cosmos_chain) }

  context 'logged out' do
    it 'visiting halted Cosmos Home View as not signed in user', :vcr do
      visit "cosmos/chains/#{chain.slug}"

      expect(page).to have_content(chain.name)
      expect(page).to have_content('Validators in Last Round')
      expect(page).to have_content('ROUND INFO')
    end
  end
end
