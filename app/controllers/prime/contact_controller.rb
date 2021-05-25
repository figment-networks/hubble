class Prime::ContactController < Prime::ApplicationController
  layout 'prime_sessions'

  skip_before_action :require_prime_user

  def index; end

  def create
    Prime::ContactMailer.with(form: params['form']).user_submit.deliver_now
    flash[:success] = 'Thank you, we will respond to your inquiry as soon as possible.'
    redirect_to root_path
  end
end
