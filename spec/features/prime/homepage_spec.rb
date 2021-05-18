require 'features_helper'

describe 'Prime Homepage' do
  let(:prime_user) { create(:user, prime: true) }
  let!(:polkadot) { create(:prime_network, name: 'Polkadot') }
  let!(:oasis) { create(:prime_network, name: 'Oasis') }
  let!(:polkadot_chain) do
    create(:prime_chain,
           network: polkadot,
           api_url: 'http://localhost:2222')
  end

  let!(:oasis_chain) do
    create(:prime_chain,
           network: oasis,
           api_url: 'https://localhost:1111',
           name: 'Mainnet',
           slug: 'mainnet',
           type: 'Prime::Chains::Oasis',
           reward_token_remote: 'oasis-labs',
           active: false)
  end

  context 'signed in prime user' do
    it 'displays Prime homepage', :vcr do
      log_in(prime_user)
      visit('/prime')

      expect(page).to have_content('Figment Prime')
      expect(page).to have_content('Polkadot')
      expect(page).to have_content('Oasis')
      expect(page).to have_content('Coming to Prime Soon!')
      expect(page).to have_content('1-Day Performance:')
      expect(page).to have_content('NETWORK UPDATES')
      expect(page).to have_content('Multi-Blockchain Support')
      expect(page).to have_content('NETWORK CALENDAR')
      expect(page).to have_content('FIGMENT VALIDATORS PERFORMANCE')
      expect(page).to have_content('Polkadot (138QdRbUTB9eNY9...)')
      expect(page).to have_content('98.09%')
    end
  end
end
