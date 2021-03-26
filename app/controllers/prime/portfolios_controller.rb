class Prime::PortfoliosController < Prime::ApplicationController
  def index
    @new_account = Prime::Account.new
    @network_token_balances = @current_user.network_balances
  end
end
