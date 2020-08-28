module Polkadot
  class Client < Common::IndexerClient
    DEFAULT_LATEST_HEIGHT = 0
    DEFAULT_HISTORY_LIMIT = 90

    def status
      Polkadot::Status.new(get("/status"))
    rescue Common::IndexerClient::Error
      Polkadot::Status.failed
    end

    def account(address)
      Polkadot::Account.new(get('/account/by_height', params: { address: address }))
    end

    def account_details(address)
      Rails.cache.fetch([self.class.name, 'account_details', address].join('-'), expires_in: 1.hour) do
        Polkadot::AccountDetails.new(get("/account/details/#{address}"))
      end
    end

    def block(height)
      Polkadot::Block.new(get('/block', params: { height: height }))
    end

    def transactions(height)
      block(height).transactions
    end

    def transaction(height, transaction_id)
      transactions(height).find { |transaction| transaction.hash == transaction_id }
    end

    def validators(height = DEFAULT_LATEST_HEIGHT)
      @validators ||= Polkadot::ValidatorsFetcher.new(self).perform(height)
    end

    def validator_daily_stake(days_limit = DEFAULT_HISTORY_LIMIT)
      get('/validator/summary_for_all', params: { interval: 'daily' })[0..(days_limit - 1)].map do |summary|
        Polkadot::ValidatorSummary.new(
          summary.slice('total_stake_avg', 'time_bucket').merge(validators_count: validators_count)
        )
      end
    end

    def validators_uptime(height = DEFAULT_LATEST_HEIGHT)
      get('/validator/for_min_height', params: { height: height })['items']
    end

    def validators_by_height(height = DEFAULT_LATEST_HEIGHT)
      get('/validator/by_height', params: { height: height })
    end

    private

    def validators_count
      Rails.cache.fetch([self.class.name, 'validators_count'].join('-'), expires_in: 1.day) do
        validators_uptime.count
      end
    end
  end
end
