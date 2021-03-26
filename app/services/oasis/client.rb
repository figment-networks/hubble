module Oasis
  class Client < Common::IndexerClient
    DEFAULT_TIMEOUT = 5

    def status
      Oasis::Status.new(get('/status'))
    rescue Common::IndexerClient::Error
      Oasis::Status.failed
    end

    def current_block
      Oasis::Block.new(get('/block'))
    end

    def block(id)
      Oasis::Block.new(get('/block', height: id))
    end

    def block_times(limit = 100)
      Oasis::BlockTime.new(get("/block_times/#{limit}"))
    end

    def blocks_summary(interval = 'hour', period = '48 hours')
      get('/blocks_summary', period: period, interval: interval).map do |point|
        Oasis::IntervalStat.new(point)
      end
    end

    def staking(height)
      Oasis::Staking.new(get('/staking', height: height))
    end

    def validators
      get('/validators/for_min_height/1')['items'].map do |val|
        Oasis::Validator.new(val)
      end
    end

    def validator(address, limit = 0, network: nil, retrieve_delegations: true)
      validator = Oasis::Validator.new(get("/validator/#{address}", sequences_limit: limit), network: network)
      if retrieve_delegations
        delegations = get('/delegations')['items'].select do |d|
          d['validator_uid'] == validator.address
        end

        validator.delegations = delegations.map do |delegation|
          Oasis::Delegation.new(delegation)
        end

        debonding_delegations = get('/debonding_delegations')['items']

        return validator if debonding_delegations.nil?

        debonding_delegations = debonding_delegations.select { |d| d['validator_uid'] == validator.address }
        debonding_delegations.map do |delegation|
          validator.delegations << Oasis::Delegation.new(delegation, 'debonding')
        end
      end
      return validator
    end

    def validators_by_height(height)
      get('/validators', height: height)['items'].map do |val|
        Oasis::Validator.new(val)
      end
    end

    def validators_summary(interval = 'hour', period = '48 hours', address = nil)
      get('/validators_summary', period: period, interval: interval,
                                 address: address).map do |point|
        Oasis::IntervalStat.new(point)
      end
    end

    def account(address, retrieve_delegations: true)
      Rails.cache.fetch([self.class.name, 'account_details', address].join('-'), expires_in: SHORT_EXPIRY_TIME) do
        account = Oasis::Account.new(get("/account/#{address}"), address)

        if retrieve_delegations
          delegations = get('/delegations')['items'].select { |d| d['delegator_uid'] == address }
          account.delegations = delegations.map do |delegation|
            Oasis::Delegation.new(delegation)
          end

          debonding_delegations = get('/debonding_delegations')['items']

          return account if debonding_delegations.nil?

          debonding_delegations = debonding_delegations.select { |d| d['delegator_uid'] == address }
          debonding_delegations.each do |delegation|
            account.delegations << Oasis::Delegation.new(delegation, 'debonding')
          end
        end
        return account
      end
    end

    def prime_rewards(prime_account)
      Rails.cache.fetch([self.class.name, 'rewards', prime_account.address].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        token_factor = prime_account.network.primary.reward_token_factor
        token_display = prime_account.network.primary.reward_token_display
        list = get("/balance/#{prime_account.address}") || []
        list.map do |reward|
          Prime::Reward::Oasis.new(reward, prime_account, token_factor: token_factor, token_display: token_display)
        end
      end
    end

    def transactions(height)
      list = get('/transactions', height: height)['items'] || []

      list.map do |transaction|
        Oasis::Transaction.new(transaction)
      end
    end

    def transaction(height, public_key)
      list = get('/transactions', height: height)['items']
      list.each do |transaction|
        if transaction['public_key'] == public_key
          return Oasis::Transaction.new(transaction)
        end
      end
      return nil
    end

    def validator_events(chain, address, after = nil)
      events_list = get("/system_events/#{address}", after: after)['items'] || []
      events_list.map { |event| Oasis::EventFactory.generate(event, chain) }
    end

    def rewards(address)
      get("/balance/#{address}").map { |rewards| Oasis::RewardsReport.new(rewards) }
    end

    def get_alertable_name(address)
      # to be updated to pull entity_name once that PR is merged
      validator = validator(address, 0)
      validator.entity_name.presence || validator.address
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

    def retrieve_events(chain, address, seconds_ago)
      # get events from twice the supplied timeframe to ensure all unsent events are picked up
      blocks_back = (seconds_ago * 2) / block_times(1000).avg
      start_block = (current_block.height - blocks_back).round.to_i

      validator_events(chain, address, start_block)
    end
  end
end
