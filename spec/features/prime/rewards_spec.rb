require 'features_helper'

describe 'Prime Rewards' do
  let(:prime_user) { create(:user, prime: true) }
  let!(:polkadot) { create(:prime_network, name: 'Polkadot') }
  let!(:polkadot_chain) do
    create(:prime_chain,
           network: polkadot,
           name: 'Polkadot',
           slug: 'polkadot',
           api_url: 'http://localhost:2222')
  end
  let!(:prime_account) { create(:prime_account, user: prime_user, network: polkadot) }

  context 'signed in prime user' do
    xit 'displays Prime Rewards Page', :vcr do
      log_in(prime_user)
      visit('/prime/rewards')

      expect(page).to have_content('Figment Prime')
      expect(page).to have_content('My Rewards')
      expect(page).to have_content('CSV FILES')
      expect(page).to have_content('1.80 DOT')
      expect(page).to have_content('($64.89)')

      expect(page).to have_content('REWARDS OVERVIEW')

      expect(page).to have_content('14ShUZUYUR35RBZW6...')
      expect(page).to have_content('0.43 DOT')
      expect(page).to have_content('$14.78')
    end
  end
end
