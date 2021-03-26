require 'features_helper'

describe 'Livepeer Delegator List Reports', livepeer: :factory do
  include_context 'Livepeer delegator data'

  let!(:user) { create(:user) }

  let!(:delegator_list) do
    create(
      :livepeer_delegator_list,
      user: user,
      chain: chain,
      addresses: delegators
    )
  end

  context 'as a signed in user', :vcr do
    before { log_in(user) }

    let(:end_date) { rounds[1].initialized_at.to_date }
    let(:start_date) { rounds[0].initialized_at.to_date }

    it 'generates a round report' do
      visit "/livepeer/chains/#{chain.slug}/delegator_lists"

      find('a .fa-file').click

      expect(page).to have_content('Generate a report')
      expect(page).to have_content('DELEGATOR LIST REPORT')

      choose 'Round'

      select '1000', from: 'Round number'

      click_button 'Generate'

      expect(page).to have_content('Delegator List Report')

      expect(page).to have_content('5583...1D56')
      expect(page).to have_content('10 ETH 100 LPT 100 LPT 50 LPT 500 LPT 0 LPT')

      expect(page).to have_content('CB31...0E04')
      expect(page).to have_content('20 ETH 200 LPT 200 LPT 100 LPT 0 LPT 200 LPT')

      expect(page).to have_content("DELEGATOR LIST\n#{delegator_list.name}")
      expect(page).to have_content("ROUND\n1000")
    end

    it 'generates a date range report' do
      visit "/livepeer/chains/#{chain.slug}/delegator_lists"

      find('a .fa-file').click

      expect(page).to have_content('Generate a report')
      expect(page).to have_content('DELEGATOR LIST REPORT')

      choose 'Date range'

      find('#start-date').set(start_date)
      find('#end-date').set(end_date)

      click_button 'Generate'

      expect(page).to have_content('Delegator List Report')

      expect(page).to have_content('5583...1D56')
      expect(page).to have_content('40 ETH 400 LPT 300 LPT 150 LPT 1.2K LPT 300 LPT')

      expect(page).to have_content('CB31...0E04')
      expect(page).to have_content('60 ETH 600 LPT 400 LPT 200 LPT 800 LPT 200 LPT')

      expect(page).to have_content("DELEGATOR LIST\n#{delegator_list.name}")

      expect(page).to have_content("Start date: #{start_date}")
      expect(page).to have_content("End date: #{end_date}")
    end
  end
end
