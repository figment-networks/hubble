class Oasis::ChainsController < Oasis::BaseController
  before_action :set_behind_chain_alert

  def show
    page_title @chain.network_name, @chain.name, 'Overview', 'Validators and Community Pool'
    meta_description "#{@chain.network_name} -- #{@chain.name} list of Validators, Address/Name, Voting Power, Uptime, and Current Block"

    @height = @chain.client.status.last_indexed_height
    @validators = @chain.client.validators
    @common_pool = @chain.client.staking(@height).common_pool
    @voting_power = @validators.sum(&:recent_active_escrow_balance)
  rescue Common::IndexerClient::Error => error
    @error = error
  end

  def search
    flash[:warning] = 'Sorry, search on this network is currently unavailable!'
    redirect_to oasis_chain_path(@chain)
  end
end
