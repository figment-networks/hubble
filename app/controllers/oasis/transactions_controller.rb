class Oasis::TransactionsController < Oasis::BaseController
  def show
    page_title 'Overview'

    @block = @chain.client.block(params[:block_id])
    @transaction = @chain.client.transaction(params[:block_id], params[:id])
  rescue Common::IndexerClient::Error => error
    @error = error
  end
end
