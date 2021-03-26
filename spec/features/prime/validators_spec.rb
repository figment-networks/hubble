require 'features_helper'

describe 'Prime Validators' do
  let(:prime_user) { create(:user, prime: true) }
  let!(:polkadot) { create(:prime_network, name: 'Polkadot') }
  let!(:polkadot_chain) do
    create(:prime_chain,
           network: polkadot,
           name: 'Polkadot',
           slug: 'polkadot',
           api_url: 'http://localhost:2222',
           figment_validator_addresses: %w[138QdRbUTB9eNY94Q4Mj5r39FkgMiyHCAy8UFMNA5gvtrfSB
                                           12NEHw7QgwX61xGe9kahhVqMGCi6MY8fq6iBcwNJvj3Y7Nwj])
  end

  let!(:user_account) { create(:prime_account, user: prime_user, network: polkadot) }

  context 'signed in prime user' do
    it 'displays Prime Validatorss Page', :vcr do
      log_in(prime_user)
      visit('/prime/validators')

      expect(page).to have_content('Figment Prime')
      expect(page).to have_content('Validator Performance')
      expect(page).to have_content('Avg. Uptime')
      expect(page).to have_content('99.04%')
      expect(page).to have_content('FIGMENT VALIDATORS PERFORMANCE')
      expect(page).to have_content('Polkadot (138QdRbUTB9eNY9...)')
      expect(page).to have_content('98.09%')
      expect(page).to have_content('10%')
      expect(page).to have_content('VALIDATOR EVENTS')
      expect(page).to have_content('Active Set Inclusion')
    end
  end
end
