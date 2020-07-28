class Cosmoslike::DashboardController < Cosmoslike::BaseController
  before_action :require_user

  #TODO: this action and controller is shared between Cosmoslike and networks based on indexers.
  # We might want to move it to `common`
  def index
    page_title @chain.network_name, @chain.name, 'Dashboard'
  end

end
