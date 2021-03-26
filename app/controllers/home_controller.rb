require 'cryptocompare'

class HomeController < Hubble::ApplicationController
  layout 'home'

  TOKEN_PRICE_LIST = %i[ATOM LPT KAVA DOT XTZ LUNA IRIS CELO NEAR AVAX MINA ROSE].freeze

  def index
    page_title 'Hubble'
    @token_prices = Rails.cache.fetch('token_prices', expires_in: 4.hours) do
      Cryptocompare::Price.find(TOKEN_PRICE_LIST, :USD)
    end
  rescue StandardError
    @token_prices = nil
  end

  def catch_404
    raise ActionController::RoutingError, params[:path]
  end
end
