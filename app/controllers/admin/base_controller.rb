class Admin::BaseController < Hubble::ApplicationController
  include AdminHelper

  before_action :require_administrator
  before_action :require_2fa

  skip_before_action :get_user

  around_action :set_timezone, if: -> { helpers.current_admin }

  layout 'admin'
end
