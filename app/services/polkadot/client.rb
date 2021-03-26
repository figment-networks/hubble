module Polkadot
  class Client < Common::IndexerClient
    DEFAULT_TIMEOUT = 10
    DEFAULT_DAYS_LIMIT = 89
    DEFAULT_HOURS_LIMIT = 24
    DEFAULT_SESSIONS_LIMIT = 1
    DEFAULT_ERAS_LIMIT = 1

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
        raw_account_details = get("/account_details/#{address}")
        Polkadot::AccountDetails.new(raw_account_details.merge(raw_account_details['account']))
      end
    end

    def prime_rewards(prime_account)
      Rails.cache.fetch([self.class.name, 'rewards', prime_account.address].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        token_factor = prime_account.network.primary.reward_token_factor
        token_display = prime_account.network.primary.reward_token_display
        list = get("/rewards/#{prime_account.address}") || []
        list.map do |reward|
          Prime::Reward::Polkadot.new(reward, prime_account, token_factor: token_factor, token_display: token_display)
        end
      end
    end

    def block(height)
      Rails.cache.fetch([self.class.name, 'block', height].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        Polkadot::Block.new(get('/block', height: height))
      end
    end

    def block_times(limit = nil)
      get("/block_times/#{limit}")['avg']
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
        validators_summary(params: { interval: 'day', period: "#{days_limit} days" }, resource_class: Polkadot::ValidatorsSummary)
      end
    end

    def validator_daily_stake(address, days_limit = DEFAULT_DAYS_LIMIT)
      validators_summary(params: { stash_account: address, interval: 'day', period: "#{days_limit} days" }, resource_class: Polkadot::ValidatorSummary)
    end

    def validator_hourly_uptime(address, hours_limit = DEFAULT_HOURS_LIMIT)
      validators_summary(params: { stash_account: address, interval: 'hour', period: "#{hours_limit} hours" }, resource_class: Polkadot::ValidatorSummary)
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

    def validator(stash_account, network: nil)
      Polkadot::ValidatorFetcher.new(self).perform(stash_account, network: network)
    end

    def validator_details(stash_account)
      get("/validator/#{stash_account}", sessions_limit: DEFAULT_SESSIONS_LIMIT, eras_limit: DEFAULT_ERAS_LIMIT)
    end

    def validators_count
      Rails.cache.fetch([self.class.name, 'validators_count'].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        validators_uptime(status.indexed_validators_height).count
      end
    end

    def validator_events(chain:, address:, types: nil, start_date: nil, end_date: nil, start_block: nil)
      raw_events = get("/system_events/#{address}", after: start_block)['items'] || []
      events = raw_events.map { |event| Polkadot::EventFactory.generate(event, chain) }
      events.select! { |event| types.include?(event.kind_class) } if types.present?
      events.select! { |event| event.time >= Time.zone.parse(start_date) } if start_date.present?
      events.select! { |event| event.time <= Time.zone.parse(end_date).end_of_day } if end_date.present?
      events.sort_by(&:time).reverse
    end

    def get_alertable_name(address)
      validator = validator(address)
      validator.display_name.presence || validator.address
    end

    def get_recent_events(chain, address, klass, time_ago)
      all_events = retrieve_events(chain, address, Time.now - time_ago)
      all_events.select { |e| e.time >= time_ago && klass == "Common::ValidatorEvents::#{e.kind_class.classify}".constantize }
    end

    def get_events_for_alert(chain, subscription, seconds_ago, date = nil)
      all_events = retrieve_events(chain, subscription.alertable.address, seconds_ago)

      # filter out events prior to last alert time
      if !date
        filtered_events = all_events.select { |e| e.time > subscription.last_instant_at }
      else
        filtered_events = all_events.select do |e|
          e.time >= date.beginning_of_day && e.time <= date.end_of_day
        end
      end
    end

    private

    def validators_summary(params:, resource_class: Polkadot::ValidatorSummary)
      validators_summary = get('/validators_summary', params)
      all_summaries = validators_summary['items'].map do |summary|
        resource_class.new(summary.merge('validators_count' => validators_count))
      end
      last_indexed_era_time = Time.zone.parse(validators_summary['last_indexed_era']['time'])
      all_summaries.select { |summary| summary.indexing_completed?(last_indexed_era_time) }
    end

    def retrieve_events(chain, address, seconds_ago)
      # get events from twice the supplied timeframe to ensure all unsent events are picked up
      blocks_back = (seconds_ago * 2) / block_times(1000)
      start_block = (status.last_block_height - blocks_back).round.to_i
      validator_events(chain: chain, address: address, start_block: start_block)
    end
  end
end
