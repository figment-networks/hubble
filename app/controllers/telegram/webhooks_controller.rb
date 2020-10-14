module Telegram
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token
    skip_before_action :http_basic_auth if REQUIRE_HTTP_BASIC

    def create
      if params[:token] != Rails.application.secrets.telegram_api_key
        raise ActionController::NotFound
      end

      if params[:message] && params[:message][:chat] && params[:message][:chat][:username]
        account = Telegram::Account.by_username(params[:message][:chat][:username])

        if account && account.chat_id != params[:message][:chat][:id].to_s
          account.update(chat_id: params[:message][:chat][:id])
          Telegram::Message.send(account: account,
                                 message: 'Welcome to Hubble Alerts on Telegram! We’ll send you messages here for events you subscribe to in Hubble.')
        end
      end

      head :no_content
    end
  end
end
