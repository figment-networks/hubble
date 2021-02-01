require 'features_helper'

describe 'polkadot validators' do
  let(:chain) { create(:polkadot_chain) }
  let(:user) { create(:user) }

  context 'logged out' do
    it 'visiting list of validators as signed out user', :vcr do
      visit "/polkadot/chains/#{chain.slug}"

      expect(page).to have_content('Polkadot')
      expect(page).to have_content('TOTAL STAKE')
      expect(page).to have_content('CURRENT BLOCK')
      # TODO: fix when full_name becomes available in indexer
      # expect(page).to have_content('DragonStake')
      expect(page).to have_content('153RWxqZyAWBM2brLkBEkYmyVyf5aMqGHew...')

      click_on('153RWxqZyAWBM2brLkBEkYmyVyf5aMqGHew...')

      expect(page).to have_content('153RWxqZyAWBM2brLkBEkYmyVyf5aMqGHewbvG3jqENyCKyC')
      expect(page).to have_content('TOTAL STAKE HISTORY')
      expect(page).to have_content('UPTIME HISTORY')
      expect(page).to have_content('Event History')
      expect(page).to have_content('left delegator set')
    end
  end

  context 'logged in' do
    it 'visiting list of validators as signed in user', :vcr do
      log_in(user)
      visit "/polkadot/chains/#{chain.slug}/validators/153RWxqZyAWBM2brLkBEkYmyVyf5aMqGHewbvG3jqENyCKyC"
      expect(page).to have_content('Subscribe to Alerts')

      click_on('Subscribe to Alerts')
      expect(page).to have_content('Subscribe to Events')
      expect(page).to have_content('Voting Power Change %')
      expect(page).to have_content('Joined/Left the Active Set')
      expect(page).to have_content('There have been 0 instances in the past week.')
    end
  end
end
