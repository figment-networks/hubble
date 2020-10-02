class Admin::BaseController < ApplicationController
  include AdminHelper

  before_action :require_administrator
  before_action :require_2fa

  skip_before_action :get_user

  around_action :set_timezone, if: -> { helpers.current_admin }

  layout 'admin'

  private

  def require_administrator
    unless helpers.current_admin
      session[:after_admin_login_path] = request.fullpath
      redirect_to new_admin_session_path
      return false
    end
  end

  def require_2fa
    return if helpers.current_admin.nil?

    if helpers.current_admin.one_time_setup_token?
      session[:after_admin_login_path] = request.fullpath
      redirect_to setup_admin_administrators_path
      return false
    end
  end

  def set_timezone(&block)
    Rails.logger.debug 'SETTING TIMEZONE TO EST FOR ADMIN'
    Time.use_zone('Eastern Time (US & Canada)', &block)
  end
end
