module Polkadot
  class Client < Common::IndexerClient
    DEFAULT_LATEST_HEIGHT = 0
    DEFAULT_DAYS_LIMIT = 90
    DEFAULT_HOURS_LIMIT = 48

    def status
      Polkadot::Status.new(get('/status'))
    rescue Common::IndexerClient::Error
      Polkadot::Status.failed
    end

    def account(address)
      Polkadot::Account.new(get('/account/by_height', params: { address: address }))
    end

    def account_details(address)
      # TODO: remove hardcoded address when we use a real indexer. Without this line we get a lot of 404s
      # for validators list and it's very slow on staging
      return AccountDetails.failed(address) if address != 'DSpbbk6HKKyS78c4KDLSxCetqbwnsemv2iocVXwNe2FAvWC'

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

    def validators_daily_stake(days_limit = DEFAULT_DAYS_LIMIT)
      get('/validator/summary_for_all', params: { interval: 'day' })[0..(days_limit - 1)].map do |summary|
        Polkadot::ValidatorsSummary.new(
          summary.slice('total_stake_avg', 'time_bucket').merge(validators_count: validators_count)
        )
      end
    end

    def validator_daily_stake(address, days_limit = DEFAULT_HOURS_LIMIT)
      get('/validator/summary_for_one', params: { stash_account: address, interval: 'day' })[0..(days_limit - 1)].map do |summary|
        Polkadot::ValidatorSummary.new(summary.slice('total_stake_avg', 'time_bucket'))
      end
    end

    # TODO: might need to refactor with `validator_daily_stake` when we start using a real indexer
    def validator_hourly_uptime(address, hours_limit = DEFAULT_DAYS_LIMIT)
      get('/validator/summary_for_one_hourly', params: { stash_account: address, interval: 'hour' })[0..(hours_limit - 1)].map do |summary|
        Polkadot::ValidatorSummary.new(summary.slice('uptime_avg', 'time_bucket'))
      end
    end

    def validators_uptime(height = DEFAULT_LATEST_HEIGHT)
      get('/validator/for_min_height', params: { height: height })['items']
    end

    def validators_by_height(height = DEFAULT_LATEST_HEIGHT)
      get('/validator/by_height', params: { height: height })
    end

    def validator(height = DEFAULT_LATEST_HEIGHT)
      Polkadot::ValidatorFetcher.new(self).perform(height)
    end

    def validator_details(_height)
      # TODO: use height and change endpoint when switching to real indexer
      # sessions_limit (optional) - number of last sessions
      # include eras_limit (optional)
      get('/validator/details')
    end

    private

    def validators_count
      Rails.cache.fetch([self.class.name, 'validators_count'].join('-'), expires_in: 1.day) do
        validators_uptime.count
      end
    end
  end
end
