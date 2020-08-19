class Oasis::DashboardController < Oasis::BaseController
  before_action :require_user

  def index
    @subscriptions = @chain.alert_subscriptions.where(user: current_user)
    page_title @chain.network_name, @chain.name, 'Dashboard'
  end

end
