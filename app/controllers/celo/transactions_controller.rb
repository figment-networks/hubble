class Celo::TransactionsController < Celo::BaseController
  def show
    @transaction = client.transaction(params[:block_id], params[:id])
    raise ActionController::NotFound unless @transaction

    respond_to do |format|
      format.html
      format.json { render json: { transaction: @transaction } }
    end
  end
end
