class Prime::ApplicationController < ApplicationController
  layout 'prime'

  include Prime::ApplicationHelper

  before_action :require_prime_user

  private

  def require_prime_user
    if !current_user
      flash[:warning] = 'You must be logged in to access the Prime Dashboard.'
      redirect_to prime_login_path
    elsif !current_user.prime?
      redirect_to prime_contact_path
    end
  end
end
