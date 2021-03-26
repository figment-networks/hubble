class Prime::HomeController < Prime::ApplicationController
  NETWORK_EVENTS_LIMIT = 10

  def index
    @new_account = Prime::Account.new
  end
end
