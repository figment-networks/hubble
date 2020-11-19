require 'uri'
require 'net/http'

module Telegram
  class Message
    class << self
      def send(account:, message:)
        return if account.chat_id.blank?

        uri = URI("https://api.telegram.org/bot#{Rails.application.secrets.telegram_api_key}/sendMessage")
        params = { chat_id: account.chat_id, text: message, parse_mode: 'html' }
        uri.query = URI.encode_www_form(params)

        Net::HTTP.get_response(uri)
      end

      def send_tezos_alert(subscription:, events:, type:, date: nil)
        user = subscription.user

        if user.has_telegram_account?
          send(
            account: user.telegram_account,
            message: tezos_alert_message(
              subscription: subscription,
              events: events,
              type: type,
              date: date
            )
          )
        end
      end

      def tezos_alert_message(subscription:, events:, type:, date: nil)
        [
          identifiers(subscription.alertable),
          summary(subscription, events, type, date),
          details(events)
        ].join.truncate(4000)
      end

      private

      def identifiers(alertable)
        "<strong>Baker:</strong> #{alertable.long_name}\n<strong>Chain:</strong> #{alertable.chain.name}\n"
      end

      def summary(subscription, events, type, date)
        if type == :instant
          "<strong>There #{events.count == 1 ? 'has' : 'have'} been #{events.count} new #{'event'.pluralize(events.count)} since we last notified you (on #{subscription.last_instant_at.strftime('%Y-%m-%d %H:%M %Z')}):</strong> \n"
        else
          "<strong>Here is your daily digest for #{date.strftime('%B %d, %Y')}. There #{events.count == 1 ? 'was' : 'were'} #{events.count} new #{'event'.pluralize(events.count)} today.</strong> \n"
        end
      end

      def details(events)
        events.any? ? events.map(&:to_s).join("\n") : ''
      end
    end
  end
end
