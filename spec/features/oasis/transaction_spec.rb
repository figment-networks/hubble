require 'features_helper'

describe 'oasis transactions' do
  let!(:chain) { create(:oasis_chain, api_url: 'https://localhost:1111') }
  let(:transaction_id) { 'CeK2kK5crFPeQaYmRG%2Fy3H7xt+j+yKDFoIluRKRGXgM=' }
  let(:block_id) { 5933 }

  context 'logged out' do
    it 'visiting Oasis Transaction View as not signed in user', :vcr do
      visit "/oasis/chains/#{chain.slug}/blocks/#{block_id}/transactions/#{transaction_id}"

      expect(page).to have_content('Oasis')
      expect(page).to have_content(block_id)
      expect(page).to have_content('Transaction Details')
      expect(page).to have_content('Timestamp')
      expect(page).to have_content('Fees')
    end
  end

  context 'logged in' do
    # to be further scoped out when logged in features become available
  end
end
