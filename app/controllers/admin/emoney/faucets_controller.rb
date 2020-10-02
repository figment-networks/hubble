class Admin::Emoney::FaucetsController < Admin::Cosmoslike::FaucetsController
  protected

  def ensure_chain
    @chain = ::Emoney::Chain.find_by(slug: params[:chain_id])
  end
end
