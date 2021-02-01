require 'features_helper'

describe 'Prime Homepage' do
  let(:prime_user) { create(:user, prime: true) }

  context 'signed in prime user' do
    it 'displays Prime homepage' do
      log_in(prime_user)
      visit('/prime')

      expect(page).to have_content('Welcome to Prime')
    end
  end
end
