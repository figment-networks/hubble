module Avalanche
  class Client < Common::IndexerClient
    def status
      @status ||= Avalanche::Status.new(get('/status'))
    rescue Common::IndexerClient::Error
      Avalanche::Status.failed
    end
  end
end
