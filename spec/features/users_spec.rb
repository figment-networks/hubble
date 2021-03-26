require 'features_helper'

describe 'User Settings' do
  let(:user) { create(:user) }

  context 'signed in user' do
    it 'displays User Settings page', :vcr do
      log_in(user)
      visit('/users/settings')

      expect(page).to have_content('Settings')
      expect(page).to have_content('User Info')

      fill_in 'user_password', with: 'pass'
      click_button 'Update'

      expect(page).to have_content('Please use a more secure password')

      fill_in 'user_password', with: 'password123'
      click_button 'Update'

      expect(page).to have_content('User info updated.')
    end
  end
end
