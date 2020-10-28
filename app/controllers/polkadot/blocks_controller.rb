class Polkadot::BlocksController < Polkadot::BaseController
  def show
    status = client.status
    raise ActionController::NotFound if params[:id].to_i > status.last_indexed_height

    @block = Common::BlockDecorator.new(client.block(params[:id]), status)
    @transactions = @block.transactions
    @validators_height = [@block.height, status.last_indexed_era_height].min
    validators_sessions_height = [@block.height, status.last_indexed_session_height].min
    @validators = fetch_validators(@validators_height, validators_sessions_height)

    respond_to do |format|
      format.html
      format.json do
        render json: { block: @block, transactions: @transactions, validators: @validators }
      end
    end
  end

  private

  def fetch_validators(height, sessions_height)
    client.validators(height, sessions_height)
  rescue Common::IndexerClient::Error
    []
  end
end
