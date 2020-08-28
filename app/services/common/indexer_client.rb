class Common::IndexerClient
  DEFAULT_TIMEOUT = 3

  class Error         < StandardError; end
  class NotFoundError < Error; end

  def initialize(endpoint, options = {})
    @endpoint = endpoint
    @timeout  = options[:timeout] || DEFAULT_TIMEOUT
  end

  private

  def get(path, params = {})
    resp = RestClient::Request.execute(
      method:  :get,
      url:     "#{@endpoint}#{path}",
      headers: { params: params },
      timeout: @timeout
    )
    JSON.load(resp.body)
  rescue RestClient::NotFound => err
    # in general we shouldn't log these to error, but indexers very rarely return 404
    # so let's have an eye on it
    Rails.logger.error(err)
    raise Common::IndexerClient::NotFoundError, err
  rescue StandardError => err
    Rails.logger.error(err)
    raise Common::IndexerClient::Error, err
  end
end
