class Mina::AccountsController < Mina::BaseController
  def show
    @account = client.account(params[:id])
    @delegations = client.delegations(public_key: @account.public_key)
    @transactions = client.transactions(account: @account.public_key)

    page_title 'Account'
    meta_description "Account #{@account.public_key}"
  end
end
