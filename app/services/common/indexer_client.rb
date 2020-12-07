class Common::IndexerClient
  DEFAULT_TIMEOUT = 3
  MEDIUM_EXPIRY_TIME = 1.hour
  SHORT_EXPIRY_TIME = 15.minutes
  DEFAULT_LATEST_HEIGHT = 0

  class Error         < StandardError; end
  class NotFoundError < Error; end

  def initialize(endpoint, options = {})
    @endpoint = endpoint
    @timeout  = options[:timeout] || self.class::DEFAULT_TIMEOUT
  end

  def get(path = nil, params = {})
    request(path, :get, params)
  end

  def post(path = nil, params = {}, body: {}, content_type: nil)
    request(path, :post, params, body, content_type)
  end

  private

  attr_reader :endpoint, :timeout

  def request(path, req_method, params = {}, body = {}, content_type = nil)
    Rails.logger.info("#{endpoint}#{path} #{params} timeout: #{timeout}")
    headers = content_type ? { 'Content-Type' => content_type, params: params } : { params: params }

    resp = RestClient::Request.execute(
      method: req_method,
      url: "#{endpoint}#{path}",
      headers: headers,
      payload: body,
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

  def handle_error(err)
    message = err
    if data = JSON.load(err.response.body) rescue nil
      message = data['error'] if data.is_a?(Hash) && data['error']
    end

    raise Common::IndexerClient::Error, message
  end
end
