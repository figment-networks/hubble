class Polkadot::AccountsController < Polkadot::BaseController
  def show
    @account_details = Polkadot::AccountDetailsDecorator.new(client.account_details(params[:id]))
  rescue Common::IndexerClient::Error => e
    @account_details = Polkadot::AccountDetails.failed(params[:id])
    @error = e
  end
end
