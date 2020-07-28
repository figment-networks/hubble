require 'features_helper'

feature 'oasis blocks' do
  let!(:chain) { create(:oasis_chain, api_url: 'https://localhost:1111') }
  let(:block_id) { 292864 }

  context 'logged out' do
    scenario 'visiting Oasis Block View as not signed in user', :vcr do
      visit "/oasis/chains/#{chain.slug}/blocks/#{block_id}"

      expect(page).to have_content("Oasis")
      expect(page).to have_content(block_id)
      expect(page).to have_content("Transactions")
      expect(page).to have_content("Validators")
      expect(page).to have_content("Timestamp")
    end
  end

  context 'logged in' do
    # to be further scoped out when logged in features become available
  end
end
