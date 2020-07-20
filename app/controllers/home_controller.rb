class HomeController < ApplicationController
  layout 'redesign/home'
  
  def index
    page_title 'Hubble'
  end

  def catch_404
    raise ActionController::RoutingError.new(params[:path])
  end
end
