class SessionsController < ApplicationController
  layout 'account'

  def new
    page_title 'Puzzle', 'Login'
    referrer = URI(request.referrer) rescue nil
    if referrer
      referrer.host, referrer.port = Rails.application.credentials[Rails.env.to_sym][:application_host].split(':')
      referrer.port = nil if referrer.port == 80
      @return_path = referrer.to_s
    end
  end

  def create
    user = User.find_by email: params[:email].try(:downcase)

    if user.nil?
      flash[:error] = "Invalid email or password."
      redirect_to login_path
      return
    end

    if !user.verified?
      redirect_to welcome_users_path
      return
    end

    if user.authenticate(params[:password]) && !user.deleted?
      session[:uid] = user.id
      session[:masq] = nil
      user.update_for_login ua: request.env['HTTP_USER_AGENT'], ip: current_ip
      redirect_to params_return_path || root_path
      return
    else
      redirect_to login_path( return_path: params_return_path )
    end
  end

  def forgot_password
  end

  def reset_password
    user = User.find_by email: params[:email].downcase
    if user && user.verified?
      user.update_attributes password_reset_token: SecureRandom.hex
      UserMailer.with(user: user).forgot_password.deliver_now
    else
      redirect_to forgot_path
    end
  end

  def recover_password
    @user = User.find_by password_reset_token: params[:token]
    raise ActiveRecord::RecordNotFound if !@user
    session[:uid] = @user.id
    session[:masq] = nil
    @user.update_attributes password_reset_token: nil
    flash[:notice] = "Logged in. You may reset your password now."
    redirect_to settings_users_path
  end

  def destroy
    admin_id = session[:admin_id]
    session[:masq] = nil
    session[:uid] = nil
    reset_session
    session[:admin_id] = admin_id if !admin_id.blank?
    redirect_to root_path
  end

end
