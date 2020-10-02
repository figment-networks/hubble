class Admin::AdministratorsController < Admin::BaseController
  skip_before_action :require_2fa, only: %i[setup]

  def index
    @administrators = Administrator.all
  end

  def new
    @administrator = Administrator.new
  end

  def create
    opts = params.require(:administrator).permit(%i[name email])
    opts[:one_time_setup_token] = SecureRandom.hex
    @administrator = Administrator.create(opts)
    if @administrator.valid? && @administrator.persisted?
      flash[:notice] = "#{@administrator.name} added as an admin. Send them their invite link to complete setup."
    end
    redirect_to admin_administrators_path
  end

  def edit
    @administrator = current_admin
    if params[:id] != current_admin.id.to_s
      redirect_to admin_administrators_path
    end
  end

  def update
    @administrator = current_admin

    if Rails.env.development? || @administrator.authenticate_otp(params[:otp_code])
      if !params[:change_password].blank?
        params[:administrator][:password] = params.delete(:change_password)
      end

      @administrator.update_attributes params.require(:administrator).permit(%i[name email password])

      if params[:reset_otp] == 'on'
        @administrator.update_attributes otp_secret_key: ROTP::Base32.random_base32
        redirect_to setup_admin_administrators_path
        return
      end

      flash[:notice] = 'Administrator info updated.'
    else
      flash[:error] = 'Incorrect 2FA code.'
    end

    redirect_to admin_administrators_path
  end

  def destroy
    @administrator = Administrator.find params[:id]
    name = @administrator.name
    @administrator.destroy
    flash[:notice] = "#{name} is no longer an admin."
    redirect_to admin_administrators_path
  end

  def setup
    if request.post?
      a = current_admin
      a.password = params[:password]
      a.otp_secret_key = params[:secret]
      a.one_time_setup_token = nil
      if Rails.env.development? || a.otp_code == params[:verification]
        a.save
        dest = session.delete :after_admin_login_path
        redirect_to dest || admin_root_path
      else
        flash[:error] = 'OTP code verification failed. Please delete the key from your authenticator app and try again.'
        redirect_to setup_admin_administrators_path
      end
    else
      @administrator = current_admin
      @secret = @administrator.otp_secret_key || ROTP::Base32.random_base32
      @qr = RQRCode::QRCode.new(
        ['otpauth://totp/', @administrator.email,
         '?secret=', @secret,
         '&issuer=', URI.escape("Hubble #{"(#{Rails.env}) " unless Rails.env.production?}Admin")].join('')
      )
    end
  end
end
