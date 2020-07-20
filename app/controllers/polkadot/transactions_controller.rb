class Polkadot::TransactionsController < Polkadot::BaseController
  def show
    page_title 'Overview'

    @transaction = client.transaction(params[:id])
  end
end
