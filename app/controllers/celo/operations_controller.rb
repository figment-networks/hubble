class Celo::OperationsController < Celo::BaseController
  def show
    transaction = client.transaction(params[:block_id], params[:transaction_id])
    raise ActionController::NotFound unless transaction

    render json: transaction.other_operations[params[:id].to_i]&.details
  end
end
