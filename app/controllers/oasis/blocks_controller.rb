class Oasis::BlocksController < Oasis::BaseController
  def show
    @height = params[:id].to_i
    @block = Common::BlockDecorator.new(@chain.client.block(@height), @chain.client.status)
    @validators = @chain.client.validators_by_height(@height)
    @transactions = @chain.client.transactions(@height)
    @voting_power = @validators.sum(&:active_escrow_balance)

    respond_to do |format|
      format.html do
        page_title @chain.network_name, @chain.name, "Transactions and Validators for block #{@block.height}"
        meta_description "#{@chain.network_name} -- #{@chain.name} - Transactions, Validators and Voting Power"
      end
      format.json do
        render json: { block: @block, transactions: @transactions, validators: @validators }
      end
    end
  rescue Common::IndexerClient::Error => error
    @block = Oasis::Block.failed(params[:id])
    @error = error
  end
end
