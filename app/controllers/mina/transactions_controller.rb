class Mina::TransactionsController < Mina::BaseController
  before_action :init_search_form, only: :index

  def index
    @transactions = client.transactions(@search_form.to_hash)

    if request.xhr?
      render partial: 'mina/transactions/index/table', locals: { transactions: @transactions }
      return
    end

    page_title 'Transaction Search'
  rescue Common::IndexerClient::Error => err
    flash[:error] = "Search request failed: #{err.message}"
    @transactions = []
  end

  def show
    @transaction = client.transaction(params[:id])

    page_title "#{@transaction.formatted_type} Details"
  end

  private

  def init_search_form
    @search_form = Mina::TransactionSearch.new(search_params.to_hash)
    @search_form.before_id = nil unless request.xhr?
  end

  def search_params
    scope = params
    scope = params.require(:search) if params[:search].present?

    scope.permit(
      :account,
      :sender,
      :receiver,
      :start_time,
      :end_time,
      :memo,
      :show,
      :before_id,
      :after_id,
      type: []
    )
  end
end
