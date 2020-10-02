class Common::DashboardController < ApplicationController
  before_action :require_user

  def index
    @chain = @namespace::Chain.find_by slug: params[:chain_id]
    raise ActionController::NotFound unless @chain

    page_title @chain.network_name, @chain.name, 'Dashboard'
    meta_description "#{@chain.network_name} -- #{@chain.name} -- Dashboard"
  end
end
