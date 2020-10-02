class UserMailer < ApplicationMailer
  def confirm
    @user = params[:user]
    @confirm_url = confirm_users_url(token: @user.verification_token)
    mail(
      to: @user.email,
      subject: 'Welcome to Hubble!'
    )
  end

  def forgot_password
    @user = params[:user]
    @recover_url = recover_password_url(token: @user.password_reset_token)
    mail(
      to: @user.email,
      subject: 'Hubble account password reset instructions.'
    )
  end
end
