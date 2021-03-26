class UsersController < ApplicationController
  layout 'account'

  before_action :require_user, only: %i[edit update post_signup]

  def new
    page_title 'Hubble', 'Signup'
    @no_chain_select = true
    redirect_to settings_users_path if current_user
    @user = User.new
  end

  def create
    @no_chain_select = true
    @user = User.create(params.require(:new_signup).permit(%i[name email password]))
    if @user.valid? && @user.persisted?
      @user.update_for_signup(ua: request.env['HTTP_USER_AGENT'], ip: current_ip)
      @user.update verification_token: SecureRandom.hex
      UserMailer.with(user: @user).confirm.deliver_now
      redirect_to welcome_users_path
      return
    else
      render :new
      return
    end
  end

  def settings
    page_title 'Hubble', 'Settings'
    @no_chain_select = true
    @user = current_user
  end

  def update
    if user_params[:password].length < 5
      flash[:error] = 'Please use a more secure password'
      redirect_back(fallback_location: root_path)
      return
    elsif current_user.update(user_params)
      flash[:success] = 'User info updated.'
      redirect_back(fallback_location: root_path)
    else
      flash[:error] = 'Unable to update user info - '
      current_user.errors.full_messages.each do |message|
        flash[:error] += "#{message} "
      end
      redirect_back(fallback_location: root_path)
    end
  end

  def welcome
    page_title 'Hubble', 'Welcome'
    @no_chain_select = true
  end

  def confirm
    @user = User.find_by verification_token: params[:token]
    if @user
      session[:uid] = @user.id
      session[:masq] = nil
      @user.update_for_login(ua: request.env['HTTP_USER_AGENT'], ip: current_ip)
      @user.update verification_token: nil
      redirect_to confirmed_users_path
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def confirmed
    page_title 'Hubble', 'Account Confirmed'
    @no_chain_select = true
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
