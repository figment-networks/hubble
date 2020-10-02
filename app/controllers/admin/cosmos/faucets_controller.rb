class Admin::Cosmos::FaucetsController < Admin::Cosmoslike::FaucetsController
  protected

  def ensure_chain
    @chain = ::Cosmos::Chain.find_by(slug: params[:chain_id])
  end
end
