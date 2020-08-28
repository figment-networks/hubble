class Livepeer::DashboardController < Livepeer::BaseController
  before_action :require_user
  before_action :require_chain

  before_action :set_default_page_title
  before_action :set_default_meta_description

  def index
    @subscriptions = @chain.alert_subscriptions.where(user: current_user)
  end
end
