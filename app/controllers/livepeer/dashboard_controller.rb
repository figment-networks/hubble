class Livepeer::DashboardController < Livepeer::BaseController
  before_action :require_chain

  def index
    redirect_to livepeer_chain_path(@chain)
  end
end
