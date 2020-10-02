require 'features_helper'

describe 'oasis accounts' do
  let!(:chain) { create(:oasis_chain, api_url: 'https://localhost:1111') }
  let(:account_id) { 'oasis1qzsp62l07fqsxgdeqszwz8hm34hhwem9ny73qnpr' }

  context 'logged out' do
    it 'visiting Oasis Account View as not signed in user', :vcr do
      visit "/oasis/chains/#{chain.slug}/accounts/#{account_id}"

      expect(page).to have_content('Oasis')
      expect(page).to have_content('Account')
      expect(page).to have_content('Delegations')
      expect(page).to have_content('Balance')
    end
  end
end
