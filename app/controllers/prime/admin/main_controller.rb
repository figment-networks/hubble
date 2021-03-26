class Prime::Admin::MainController < Prime::Admin::BaseController
  def index
    @networks = Prime::Network.all.includes([:chains])
    @prime_users = User.with_prime_access
  end
end
