class Polkadot::BlocksController < Polkadot::BaseController
  def show
    @block = Common::BlockDecorator.new(client.block(params[:id]), client.status)
    @transactions = @block.transactions
    @validators = fetch_validators(@block.height)

    respond_to do |format|
      format.html
      format.json { render json: { block: @block, transactions: @transactions, validators: @validators } }
    end
  end

  private

  def fetch_validators(height)
    client.validators(height)
  rescue Common::IndexerClient::Error
    []
  end
end
