module Avalanche
  class Client < Common::IndexerClient
    def status
      @status ||= Avalanche::Status.new(get('/status'))
    rescue Common::IndexerClient::Error
      Avalanche::Status.failed
    end

    def validators(opts = {})
      get_collection(Avalanche::Validator, '/validators', opts)
    end

    def validator(id)
      Avalanche::ValidatorDetails.new(get("/validators/#{id}"))
    end

    def network_stats(opts = {})
      get_collection(Avalanche::NetworkStat, '/network_stats', opts)
    end

    def validators_daily_stake
      total_delegated_daily
    end

    def validator_hourly_uptime_avg(node_id)
      validators_hourly_uptime_avg(node_id)
    end

    def validators_count
      Rails.cache.fetch([self.class.name, 'validators_count'].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        network_stats(bucket: 'h', limit: 1)[0].active_validators
      end
    end

    def total_delegated_daily
      get('/network_stats?bucket=d').reverse.map { |n| Avalanche::ValidatorSummary.new(n) }
    end

    def validators_hourly_uptime_avg(node_id)
      data = get("/validators/#{node_id}")
      data.stats_24h.map { |n| Avalanche::ValidatorStat.new(n) }
    end

    def account(account)
      Avalanche::Account.new(get("/address/#{account}"))
    end

    def delegations(opts = {})
      get_collection(Avalanche::Delegation, '/delegations', opts)
    end
  end
end
