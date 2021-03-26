require 'features_helper'

describe 'Prime Events' do
  let(:prime_user) { create(:user, prime: true) }
  let!(:polkadot) { create(:prime_network, name: 'Polkadot') }
  let!(:polkadot_chain) do
    create(:prime_chain,
           network: polkadot,
           name: 'Polkadot',
           slug: 'polkadot')
  end

  context 'signed in prime user' do
    it 'displays Prime Events Page', :vcr do
      log_in(prime_user)
      visit('/prime/events')

      expect(page).to have_content('Figment Prime')
      expect(page).to have_content('Network News & Events')
      expect(page).to have_content('NETWORK CALENDAR')
      expect(page).to have_content('Multi-Blockchain Support')
      expect(page).to have_content('NETWORK UPDATES')
    end
  end
end
