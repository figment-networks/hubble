class Admin::Terra::FaucetsController < Admin::Cosmoslike::FaucetsController
  protected

  def ensure_chain
    @chain = ::Terra::Chain.find_by(slug: params[:chain_id])
  end
end
