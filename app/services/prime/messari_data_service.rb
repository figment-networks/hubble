module Prime
  class MessariDataService
    BASE_URL = 'https://data.messari.io/api/'.freeze
    DEFAULT_TIMEOUT = 3
    MEDIUM_EXPIRY_TIME = 1.hour
    SHORT_EXPIRY_TIME = 15.minutes

    class Error         < StandardError; end
    class NotFoundError < Error; end

    def token_metrics(token)
      Rails.cache.fetch([self.class.name, 'token_metrics', token].join('-'), expires_in: SHORT_EXPIRY_TIME) do
        Prime::TokenMetrics.new(get("v1/assets/#{token}/metrics"))
      end
    rescue Prime::MessariDataService::Error
      Prime::TokenMetrics.failed
    end

    def token_price_time_series(token, params: {})
      Rails.cache.fetch([self.class.name, 'token_price_time_series', token].join('-'), expires_in: SHORT_EXPIRY_TIME) do
        Prime::TokenPriceTimeSeries.new(get("v1/assets/#{token}/metrics/price/time-series", params: params))
      end
    rescue Prime::MessariDataService::Error
      Prime::TokenPriceTimeSeries.failed
    end

    def network_events(network)
      params = { asset: network.primary.reward_token_remote }
      get('v1/intel/events', params: params)['data'].map do |event|
        Prime::NetworkEvent.new(event, network)
      end
    rescue Prime::MessariDataService::Error
      [Prime::NetworkEvent.failed(network)]
    end

    private

    def get(path, headers: {}, params: {}, timeout: DEFAULT_TIMEOUT)
      headers['x-messari-api-key'] = Rails.application.secrets.messari_api_key
      headers['params'] = params

      resp = RestClient::Request.execute(
        method: :get,
        url: "#{BASE_URL}#{path}",
        headers: headers,
        timeout: timeout
      )
      JSON.parse(resp.body)
    rescue RestClient::NotFound => err
      Rails.logger.error("Messari Path: #{path} Params: #{params} Error: #{err}")
      raise Prime::MessariDataService::NotFoundError, err
    rescue StandardError => err
      Rails.logger.error("Messari Path: #{path} Params: #{params} Error: #{err}")
      raise Prime::MessariDataService::Error, err
    end
  end
end
