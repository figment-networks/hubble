module Skale
  class Client < Common::IndexerClient
    DEFAULT_TIMEOUT = 5

    def status
      @status ||= Skale::Status.new(get('/health'))
    rescue Common::IndexerClient::Error
      Skale::Status.failed
    end

    def validators(opts = {})
      get_collection(Skale::Validator, '/validators', opts)
    end

    def validators_count
      Rails.cache.fetch([self.class.name, 'validators_count'].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        validators.count(&:authorized)
      end
    end

    def delegations(opts = {})
      get_collection(Skale::Delegation, '/delegations', opts)
    end
  end
end
