class Cosmoslike::TransactionsController < Cosmoslike::BaseController
  layout 'redesign/application'

  include Pagy::Backend

  def self.controller_path
    'cosmoslike/redesign/transactions'
  end

  def index
    @search_form = @chain.namespace::TransactionSearch.new(@chain, search_params.to_hash)
    @current_page = params['page'].nil? ? 1 : params['page'].to_i

    body = @search_form.to_hash(@current_page).to_json
    transactions = @chain.namespace::Client.new(@chain.tx_search_url, { timeout: 10 }).transaction_search_request(body)

    page_end = transactions.count > @chain.namespace::TransactionSearch::DEFAULT_TX_PAGE_LENGTH ? -2 : transactions.count
    @transactions = transactions[0..page_end]
    @next_page = transactions.count == @chain.namespace::TransactionSearch::DEFAULT_LIMIT
    @prev_page = @current_page > 1
  rescue @chain.namespace::TransactionSearch::Error => err
    redirect_to namespaced_path('transactions')
    flash[:error] = err.message
  rescue Common::IndexerClient::Error => err
    @transactions = []
    flash[:error] = err.message
  end

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

  private

  def search_params
    scope = params
    scope = params.require(:search) if params[:search].present?

    scope.permit(
      :limit,
      :page,
      :network,
      :chain_ids,
      :account,
      :show,
      :memo,
      :after_time,
      :before_time,
      :after_height,
      :before_height,
      type: [],
      sender: [],
      receiver: []
    )
  end
end
