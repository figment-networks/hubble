class Celo::AccountsController < Celo::BaseController
  def show
    # TODO: address hardcoded until production indexer is live
    address = '0x456f41406B32c45D59E539e4BBA3D7898c3584dA'

    @account = Celo::AccountDecorator.new(client.account(address))
    @account_details = client.account_details(address)
  rescue Common::IndexerClient::Error => e
    @account = Celo::Account.failed(params[:id])
    @account_details = Celo::AccountDetails.failed(params[:id])
    @error = e
  end
end
