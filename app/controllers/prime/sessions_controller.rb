class Prime::SessionsController < Prime::ApplicationController
  layout 'prime_sessions'

  skip_before_action :require_prime_user

  def new
    referrer = URI(request.referer) rescue nil

    if referrer && Rails.application.secrets.application_host
      referrer.host, referrer.port = Rails.application.secrets.application_host.split(':')
      referrer.port = nil if referrer.port == 80
      @return_path = referrer.to_s
    end
  end
end
