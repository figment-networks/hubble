class Admin::Polkadot::ChainsController < Admin::BaseChainsController
# TODO: rescue a common Client error 
  def show
    begin
      @status = @chain.status
    rescue StandardError => error
      flash[:error] = "Cant fetch service status: #{error}"
    end
  end

  private

  def chain_class
    ::Polkadot::Chain
  end

  def chain_params
    params.require(:polkadot_chain).permit(:name, :slug, :api_url, :testnet, :disabled)
  end
end
