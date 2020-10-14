class Common::IndexerClient
  DEFAULT_TIMEOUT = 3

  class Error         < StandardError; end
  class NotFoundError < Error; end

  def initialize(endpoint, options = {})
    @endpoint = endpoint
    @timeout  = options[:timeout] || self.class::DEFAULT_TIMEOUT
  end

  def get(path, params = {})
    resp = RestClient::Request.execute(
      method: :get,
      url: "#{endpoint}#{path}",
      headers: { params: params },
      timeout: timeout
    )
    JSON.load(resp.body)
  rescue RestClient::NotFound => err
    # in general we shouldn't log these to error, but indexers very rarely return 404
    # so let's have an eye on it
    Rails.logger.error(err)
    raise Common::IndexerClient::NotFoundError, err
  rescue RestClient::ExceptionWithResponse => err
    handle_error(err)
  rescue StandardError => err
    handle_error(err)
  end

  private

  attr_reader :endpoint, :timeout

  def handle_error(err)
    message = err
    if data = JSON.load(err.response.body) rescue nil
      message = data['error'] if data.is_a?(Hash) && data['error']
    end

    raise Common::IndexerClient::Error, message
  end
end
