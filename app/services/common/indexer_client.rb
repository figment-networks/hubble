class Common::IndexerClient
  DEFAULT_TIMEOUT = 3

  class Error < StandardError; end

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
  rescue StandardError => err
    raise Common::IndexerClient::Error, err
  end
end
