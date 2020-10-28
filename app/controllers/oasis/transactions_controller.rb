class Oasis::TransactionsController < Oasis::BaseController
  def show
    @block = @chain.client.block(params[:block_id])
    @transaction = @chain.client.transaction(params[:block_id], params[:id])
    page_title @chain.network_name, @chain.name, "Tx #{@transaction.hash}"
  rescue Common::IndexerClient::Error => error
    @error = error
  end
end
