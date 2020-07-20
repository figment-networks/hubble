class Polkadot::AccountsController < Polkadot::BaseController
  def show
    @identity = Polkadot::IdentityDecorator.new(client.identity(params[:id]))
    @account = Polkadot::AccountDecorator.new(client.account(params[:id]), @chain)
  end
end
