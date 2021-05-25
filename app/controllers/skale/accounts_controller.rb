class Skale::AccountsController < Skale::BaseController
  def index
    @accounts = client.accounts

    page_title 'Accounts'
    meta_description 'Skale Accounts'
  end

  def show
    @account = client.accounts(address: params[:id]).first
    @delegations = client.delegations(holder: params[:id]).sort_by(&:state)

    page_title 'Account Information'
    meta_description 'Skale Account Page'
  end
end
