class Polkadot::AccountsController < Polkadot::BaseController
  CLIENT_TIMEOUT = 10

  def show
    @account = Polkadot::AccountDecorator.new(client.account(params[:id]), @chain)
    @account_details = Polkadot::AccountDetailsDecorator.new(client.account_details(params[:id]))
  rescue Common::IndexerClient::Error => e
    @account_details = Polkadot::AccountDetails.failed(params[:id])
    @error = e
  end

  def client
    @client ||= namespace::Client.new(@chain.api_url, timeout: CLIENT_TIMEOUT)
  end
end
