class Admin::Polkadot::ChainsController < Admin::BaseChainsController
  def show
    @status = @chain.status
    flash[:error] = "Can't fetch service status" unless @status.success?
  end

  private

  def chain_class
    ::Polkadot::Chain
  end

  def chain_params
    params.require(:polkadot_chain).permit(:name, :slug, :api_url, :testnet, :disabled)
  end
end
