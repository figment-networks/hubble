module AdminHelper
  def current_admin
    if @_current_admin.nil? && session.has_key?(:admin_id)
      @_current_admin ||= Administrator.find_by(id: session[:admin_id])
      Rails.logger.debug "Admining as #{@_current_admin.try(:email).inspect}"
    end
    @_current_admin
  end
end
