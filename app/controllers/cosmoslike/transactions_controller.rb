class Cosmoslike::TransactionsController < Cosmoslike::BaseController
  def show
    begin
      @transaction = @chain.namespace::TransactionDecorator.new(@chain, params[:id])
      @block = @chain.blocks.find_by(height: @transaction.height) ||
               @namespace::Block.stub(@chain, @transaction.height)
    rescue StandardError
      @error = true
    end

    respond_to do |format|
      format.html do
        page_title @chain.network_name, @chain.name, "Tx #{@transaction.hash}"
      end
      format.json do
        render json: @error ? { ok: false } : @transaction.dump
      end
    end
  end
end
