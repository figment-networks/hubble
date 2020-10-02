class Cosmoslike::FaucetsController < Cosmoslike::BaseController
  def show
    @faucet = @chain.faucet
    page_title @chain.network_name, @chain.name, 'Community Faucet'
    unless @faucet
      redirect_to namespaced_path
      return
    end
  end
end
