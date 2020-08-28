class Polkadot::AccountsController < Polkadot::BaseController
  def show
    @account = Polkadot::AccountDecorator.new(client.account(params[:id]), @chain)
    @account_details = Polkadot::AccountDetailsDecorator.new(client.account_details(params[:id]))
  rescue Common::IndexerClient::Error => error
    @account_details = Polkadot::AccountDetails.failed(params[:id])
    @error = error
  end
end
