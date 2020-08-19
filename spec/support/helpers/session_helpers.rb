module SessionHelpers
  def log_in(user)
    VCR.use_cassette('Hubble/homepage') do
      visit '/login'

      fill_in 'email', with: user.email
      fill_in 'password', with: user.password

      click_button 'login'
    end
  end
end
