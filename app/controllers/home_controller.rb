class HomeController < ApplicationController
  layout 'redesign/home'

  def index
    page_title 'Hubble'
  end

  def catch_404
    raise ActionController::RoutingError, params[:path]
  end
end
