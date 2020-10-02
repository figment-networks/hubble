class Oasis::BlocksController < Oasis::BaseController
  def show
    page_title 'Overview'

    @height = params[:id].to_i
    @block = Common::BlockDecorator.new(@chain.client.block(@height), @chain.client.status)
    @validators = @chain.client.validators_by_height(@height)
    @transactions = @chain.client.transactions(@height)
    @voting_power = @validators.sum(&:active_escrow_balance)

    respond_to do |format|
      format.html
      format.json { render json: { block: @block, transactions: @transactions, validators: @validators } }
    end
  rescue Common::IndexerClient::Error => error
    @block = Oasis::Block.failed(params[:id])
    @error = error
  end
end
