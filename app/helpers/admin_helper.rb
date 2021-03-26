module AdminHelper
  def current_admin
    if @_current_admin.nil? && session.has_key?(:admin_id)
      @_current_admin ||= Administrator.find_by(id: session[:admin_id])
      Rails.logger.debug "Admining as #{@_current_admin.try(:email).inspect}"
    end
    @_current_admin
  end

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
    Time.use_zone('Eastern Time (US & Canada)', &block)
  end

  def prime_toggle_text(user)
    if user.prime?
      'Revoke Prime'
    else
      'Grant Prime'
    end
  end

  def user_index_prime_filter_text
    if params[:prime_only]
      'Show All Users'
    else
      'Show Prime Users'
    end
  end

  def user_index_prime_filter_value
    params[:prime_only] == 'true' ? nil : true
  end
end
