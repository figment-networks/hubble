require "uri"
require "net/http"

module Telegram
  class Message
    def self.send(account:, message:)
      return unless account.chat_id.present?

      uri = URI("https://api.telegram.org/bot#{Rails.application.secrets.telegram_api_key}/sendMessage")
      params = { chat_id: account.chat_id, text: message }
      uri.query = URI.encode_www_form(params)

      Net::HTTP.get_response(uri)
    end
  end
end
