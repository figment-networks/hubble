module Polkadot
  class Client < Common::IndexerClient
    DEFAULT_TIMEOUT = 5
    DEFAULT_LATEST_HEIGHT = 0
    DEFAULT_DAYS_LIMIT = 89
    DEFAULT_HOURS_LIMIT = 24
    DEFAULT_SESSIONS_LIMIT = 1
    DEFAULT_ERAS_LIMIT = 1
    SHORT_EXPIRY_TIME = 15.minutes
    MEDIUM_EXPIRY_TIME = 1.hour

    def status
      @status ||= Polkadot::Status.new(get('/status'))
    rescue Common::IndexerClient::Error
      Polkadot::Status.failed
    end

    def account(address)
      Polkadot::Account.new(get("/account/#{address}"))
    end

    def account_details(address)
      Rails.cache.fetch([self.class.name, 'account_details', address].join('-'), expires_in: SHORT_EXPIRY_TIME) do
        Polkadot::AccountDetails.new(get("/account_details/#{address}"))
      end
    end

    def block(height)
      Rails.cache.fetch([self.class.name, 'block', height].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        Polkadot::Block.new(get('/block', height: height))
      end
    end

    def transactions(height)
      block(height).transactions
    end

    def transaction(height, transaction_id)
      transactions(height).find { |transaction| transaction.hash == transaction_id }
    end

    def validators(height = DEFAULT_LATEST_HEIGHT, sessions_height = height)
      @validators ||= Polkadot::ValidatorsFetcher.new(self).perform(height, sessions_height)
    end

    def validators_daily_stake(days_limit = DEFAULT_DAYS_LIMIT)
      Rails.cache.fetch([self.class.name, 'validators_daily_stake', days_limit].join('-'), expires_in: SHORT_EXPIRY_TIME) do
        get('/validators_summary', interval: 'day', period: "#{days_limit} days").map do |summary|
          Polkadot::ValidatorsSummary.new(
            summary.merge('validators_count' => validators_count)
          )
        end
      end
    end

    def validator_daily_stake(address, days_limit = DEFAULT_DAYS_LIMIT)
      get('/validators_summary', stash_account: address, interval: 'day', period: "#{days_limit} days").map do |summary|
        Polkadot::ValidatorSummary.new(summary)
      end
    end

    def validator_hourly_uptime(address, hours_limit = DEFAULT_HOURS_LIMIT)
      get('/validators_summary', stash_account: address, interval: 'hour', period: "#{hours_limit} hours").map do |summary|
        Polkadot::ValidatorSummary.new(summary)
      end
    end

    def validators_uptime(height = DEFAULT_LATEST_HEIGHT)
      Rails.cache.fetch([self.class.name, 'validators_uptime', height].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        get("/validators/for_min_height/#{height}")['items']
      end
    end

    def validators_by_height(height = DEFAULT_LATEST_HEIGHT)
      Rails.cache.fetch([self.class.name, 'validators_by_height', height].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        get('/validators', height: height)
      end
    end

    def validator(stash_account)
      Polkadot::ValidatorFetcher.new(self).perform(stash_account)
    end

    def validator_details(stash_account)
      get("/validator/#{stash_account}", sessions_limit: DEFAULT_SESSIONS_LIMIT, eras_limit: DEFAULT_ERAS_LIMIT)
    end

    def validators_count
      Rails.cache.fetch([self.class.name, 'validators_count'].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        validators_uptime(status.last_indexed_era_height).count
      end
    end
  end
end
