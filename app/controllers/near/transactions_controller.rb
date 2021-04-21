class Near::TransactionsController < Near::BaseController
  def show
    @block = client.block(params[:block_id])
    @transaction = client.transaction(params[:id])

    page_title "Transaction #{@transaction.hash} Details"
  end
end
