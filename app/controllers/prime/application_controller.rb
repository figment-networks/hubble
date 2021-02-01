class Prime::ApplicationController < ApplicationController
  layout 'prime'

  include Prime::ApplicationHelper

  before_action :require_prime_user

  private

  def require_prime_user
    if !current_user
      flash[:warning] = 'You must be logged in to access the Prime Dashboard.'
      redirect_to login_path
    elsif !current_user.prime?
      flash[:warning] = 'To access Prime Dashboard, please contact andres@figment.io.'
      redirect_to root_path
    end
  end
end
