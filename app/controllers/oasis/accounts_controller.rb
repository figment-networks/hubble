class Oasis::AccountsController < Oasis::BaseController
  before_action :set_behind_chain_alert

  def show
    @account = @chain.client.account(params[:id])

    page_title @chain.network_name, @chain.name, @account.address
    meta_description "Delegations, Recent Delegation Transactions, Balance, and Pending Rewards for #{params[:id]}"
  rescue Common::IndexerClient::Error => error
    @account = Oasis::Account.failed(params[:id])
    @error = error
  end
end
