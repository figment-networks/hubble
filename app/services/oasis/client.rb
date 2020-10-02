module Oasis
  class Client < Common::IndexerClient
    DEFAULT_TIMEOUT = 5

    class Error < StandardError; end

    def initialize(endpoint, options = {})
      @endpoint = endpoint
      @timeout = options[:timeout] || DEFAULT_TIMEOUT
    end

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

    def validator(address, limit = 0)
      validator = Oasis::Validator.new(get("/validator/#{address}", sequences_limit: limit))
      delegations = get('/delegations')['items'].select { |d| d['validator_uid'] == validator.address }

      validator.delegations = delegations.map do |delegation|
        Oasis::Delegation.new(delegation)
      end

      debonding_delegations = get('/debonding_delegations')['items']

      return validator if debonding_delegations.nil?

      debonding_delegations = debonding_delegations.select { |d| d['validator_uid'] == validator.address }
      validator.delegations << debonding_delegations.map do |delegation|
        Oasis::Delegation.new(delegation, 'debonding')
      end
      return validator
    end

    def validators_by_height(height)
      get('/validators', height: height)['items'].map do |val|
        Oasis::Validator.new(val)
      end
    end

    def validators_summary(interval = 'hour', period = '48 hours', address = nil)
      get('/validators_summary', period: period, interval: interval, address: address).map do |point|
        Oasis::IntervalStat.new(point)
      end
    end

    def account(address)
      account = Oasis::Account.new(get("/account/#{address}"), address)
      delegations = get('/delegations')['items'].select { |d| d['delegator_uid'] == address }
      account.delegations = delegations.map do |delegation|
        Oasis::Delegation.new(delegation)
      end

      debonding_delegations = get('/debonding_delegations')['items']

      return account if debonding_delegations.nil?

      debonding_delegations = debonding_delegations.select { |d| d['delegator_uid'] == address }
      account.delegations << debonding_delegations.map do |delegation|
        Oasis::Delegation.new(delegation, 'debonding')
      end

      return account
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

    def validator_events(address, after = nil)
      list = get("/system_events/#{address}", after: after)['items'] || []

      list.map { |event| Oasis::ValidatorEvent.new(event) }
    end
  end
end
