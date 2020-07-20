class Admin::Tezos::ChainsController < Admin::BaseChainsController

  def edit
  end

  private

  def chain_class
    ::Tezos::Chain
  end

  def chain_params
    params.require(:tezos_chain).permit(:name, :slug, :indexer_api_base_url, :primary, :disabled)
  end
end
