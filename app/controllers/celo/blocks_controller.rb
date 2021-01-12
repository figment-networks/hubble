class Celo::BlocksController < Celo::BaseController
  def show
    status = client.status
    raise ActionController::NotFound if params[:id].to_i > status.last_indexed_height

    @block = Common::BlockDecorator.new(client.block(params[:id]), status)
    @transactions = fetch_transactions(params[:id])
    @validator_groups = fetch_validator_groups(params[:id])

    respond_to do |format|
      format.html
      format.json do
        render json: { block: @block, transactions: @transactions, validators: @validators }
      end
    end
  end

  private

  def fetch_transactions(height)
    client.transactions(height)
  rescue Common::IndexerClient::Error
    []
  end

  def fetch_validator_groups(height)
    client.validator_groups(height)
  rescue Common::IndexerClient::Error
    []
  end
end
