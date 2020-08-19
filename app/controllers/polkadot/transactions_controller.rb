class Polkadot::TransactionsController < Polkadot::BaseController
  def show
    page_title 'Overview'

    @transaction = Polkadot::TransactionDecorator.decorate(client.transaction(params[:block_id], params[:id]))

    respond_to do |format|
      format.html
      format.json { render json: { transaction: @transaction } }
    end
  end
end
