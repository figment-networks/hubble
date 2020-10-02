class Oasis::ChainsController < Oasis::BaseController
  before_action :set_behind_chain_alert

  def show
    page_title 'Overview'
    meta_description 'Validators'

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
