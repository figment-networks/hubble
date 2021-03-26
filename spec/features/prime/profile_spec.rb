require 'features_helper'

describe 'Prime Profile' do
  let(:prime_user) { create(:user, prime: true) }

  context 'signed in prime user' do
    it 'displays Prime User Profile page', :vcr do
      log_in(prime_user)
      visit('/prime/profile')

      expect(page).to have_content('Figment Prime')
      expect(page).to have_content('My Profile')
      expect(page).to have_content('Name')
      expect(page).to have_content('E-mail')
      expect(page).to have_content('Password')

      fill_in 'user_password', with: 'pass'
      click_button 'Update'

      expect(page).to have_content('Please use a more secure password')
      expect(page).to have_content('Figment Prime')
      expect(page).to have_content('My Profile')

      fill_in 'user_password', with: 'password123'
      click_button 'Update'

      expect(page).to have_content('User info updated.')
      expect(page).to have_content('Figment Prime')
      expect(page).to have_content('My Profile')
    end
  end
end
