class Prime::ValidatorsController < Prime::ApplicationController
  def index
    @new_account = Prime::Account.new
  end
end
