class Celo::AccountsController < Celo::BaseController
  def show
    @account = Celo::AccountDecorator.new(client.account(params[:id]))
    @account_details = client.account_details(params[:id])
  rescue Common::IndexerClient::Error => e
    @account = Celo::Account.failed(params[:id])
    @account_details = Celo::AccountDetails.failed(params[:id])
    @error = e
  end
end
