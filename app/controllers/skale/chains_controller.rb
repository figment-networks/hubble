class Skale::ChainsController < Skale::BaseController
  def show
    @status     = client.status
    @validators = client.validators
    @delegations = client.delegations

    page_title 'Overview'
    meta_description 'Validators'
  end

  def search
    flash[:warning] = 'Sorry, search on this network is currently unavailable!'
    redirect_to skale_chain_path(@chain)
  end
end
