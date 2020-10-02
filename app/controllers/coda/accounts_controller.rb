class Coda::AccountsController < Coda::BaseController
  def show
    @account      = client.account(params[:id])
    @delegations  = [] # TODO: account delegations were not available in the last testnet
    @transactions = client.transactions(account: @account.public_key)

    page_title 'Account'
    meta_description "Account #{@account.public_key}"
  end
end
