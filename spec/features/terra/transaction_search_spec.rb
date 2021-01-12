require 'features_helper'

describe 'terra transactions' do
  let!(:chain) { create(:terra_chain, name: 'Columbus 4', slug: 'columbus-4', tx_search_url: 'http://localhost:1111/transactions_search', tx_search_enabled: true) }
  let!(:chain_without_search) { create(:terra_chain) }

  context 'logged out' do
    it 'visiting Terra Transaction Search View as not signed in user', :vcr do
      visit "/terra/chains/#{chain.slug}/transactions"

      expect(page).to have_content(chain.name)
      expect(page).not_to have_content(chain_without_search.name)
      expect(page).to have_content('Columbus-4')
      expect(page).to have_content('Page 1')
      expect(page).to have_content('552928')
      expect(page).to have_content('Multisend')
      expect(page).not_to have_content('552886')

      find('#next-page', match: :first).click
      expect(page).to have_content('Page 2')
      expect(page).to have_content('552886')
      expect(page).not_to have_content('552928')

      fill_in 'search_accounts_array', with: 'terra18npmlvy8aedc6rzyhm6gkwdyd070cquatlmqtc'
      click_button 'Search'

      expect(page).to have_content(chain.name)
      expect(page).not_to have_content(chain_without_search.name)
      expect(page).to have_content('Columbus-4')
      expect(page).to have_content('Send')
      expect(page).to have_content('487337')

      fill_in 'Start Height:', with: '12345'
      fill_in 'End Height:', with: '1234'
      click_button 'Search'

      expect(page).to have_content('Start Height must be less than or equal to End Height')

      fill_in 'Start Date:', with: '2020-11-10'
      fill_in 'End Date:', with: '2020-11-01'
      click_button 'Search'

      expect(page).to have_content('Start Date must be less than or equal to End Date')
    end
  end
end
