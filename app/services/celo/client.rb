module Celo
  class Client < Common::IndexerClient
    DEFAULT_TIMEOUT = 5
    DEFAULT_BLOCK_HOURS = 48
    DEFAULT_DAYS_LIMIT = 89
    ACCOUNT_DETAILS_TRANSFERS_LIMIT = -1 # no limit
    DEFAULT_SEQUENCES_LIMIT = 1
    SCORE_FACTOR = 10 ** 24
    TRANSFER_TYPE = 'transfer'.freeze
    ACCOUNT_TRANSACTIONS_KEYS = %w[
      validator_group_vote_cast_received
      validator_group_vote_cast_sent
      gold_locked
      gold_unlocked
      gold_withdrawn
      account_slashed
      reward_received
    ].freeze

    def status
      @status ||= Celo::Status.new(get('/status'))
    rescue Common::IndexerClient::Error
      Celo::Status.failed
    end

    def block(height)
      Rails.cache.fetch([self.class.name, 'block', height].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        Celo::Block.new(get('/block', height: height))
      end
    end

    def account(address)
      Celo::Account.new(get("/account/#{address}"))
    end

    def account_details(address)
      Rails.cache.fetch([self.class.name, 'account_details', address].join('-'), expires_in: SHORT_EXPIRY_TIME) do
        raw_account_details = get("/account_details/#{address}", limit: ACCOUNT_DETAILS_TRANSFERS_LIMIT)
        operations = raw_account_details['internal_transfers_sent'].map { |operation| operation.merge(operation['data']) }
        transactions = raw_account_details.slice(*ACCOUNT_TRANSACTIONS_KEYS).values.flatten.map { |transaction| transaction.merge(transaction['data']) }
        Celo::AccountDetails.new(raw_account_details.merge(operations: operations, transactions: transactions))
      end
    end

    def transactions(height)
      raw_transactions = get('/transactions', height: height)
      transactions = raw_transactions['items'] || []
      transactions.map do |transaction|
        operations = transaction['operations'].map do |operation|
          operation.merge(operation['details']).merge(
            transaction_hash: transaction['hash'],
            height: transaction['height'],
            kind: operation['name'],
            type: operation['details']['type']
          )
        end.compact

        # unfortunately indexer in /account_details endpoint uses date time, but here it uses a unix timestamp instead
        transaction['time'] = Time.zone.at(transaction['time']).to_s

        Celo::Transaction.new(transaction.merge(operations: operations))
      end
    end

    def transaction(height, transaction_id)
      transactions(height).find { |transaction| transaction.hash == transaction_id }
    end

    def validator_groups(height = DEFAULT_LATEST_HEIGHT)
      Rails.cache.fetch([self.class.name, 'validator_groups', height].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        get_validator_groups(height).map do |validator_group|
          Celo::ValidatorGroup.new(validator_group)
        end
      end
    end

    def validator(address, sequences_limit = DEFAULT_SEQUENCES_LIMIT)
      raw_validator = get("/validator/#{address}", sequences_limit: sequences_limit)
      if last_sequence = raw_validator['last_sequences'].first
        # indexer usually returns score in floats, but this time it doesn't...
        last_sequence['score'] = last_sequence['score'].to_f / SCORE_FACTOR
        raw_validator.merge!(last_sequence)
      end
      validator = Celo::Validator.new(raw_validator)
      validator.tap { |validator| validator.validator_group = validator_group(validator.affiliation) if validator.affiliation }
    end

    def validators(address)
      raw_validators = get('/validators')['items'] || []
      raw_validators.
        select { |validator| validator['affiliation'] == address }.
        map { |validator| Celo::Validator.new(validator) }
    end

    def validator_group(address, sequences_limit = DEFAULT_SEQUENCES_LIMIT)
      validator_group = get("/validator_group/#{address}", sequences_limit: sequences_limit)
      validator_group.merge!(validator_group['last_sequences'].first) if validator_group['last_sequences']
      Celo::ValidatorGroup.new(validator_group)
    end

    def validator_groups_summary(groups_count = nil, days_limit = DEFAULT_DAYS_LIMIT)
      groups_count ||= validator_groups_count
      get('/validator_groups_summary', { interval: 'day', period: "#{days_limit} days" }).map do |summary|
        Celo::ValidatorGroupsSummary.new(summary.merge('validator_groups_count' => groups_count))
      end
    end

    def validator_daily_score(address, days_limit = DEFAULT_DAYS_LIMIT)
      params = { address: address, interval: 'day', period: "#{days_limit} days" }
      get('/validators_summary', params).map do |summary|
        Celo::ValidatorSummary.new(summary)
      end
    end

    def validator_hourly_uptime(address, limit = DEFAULT_BLOCK_HOURS)
      params = { address: address, interval: 'hour', period: "#{limit} hours" }
      get('/validators_summary', params).map do |summary|
        Celo::ValidatorSummary.new(summary)
      end
    end

    def blocks_summary(limit = DEFAULT_BLOCK_HOURS)
      get('/blocks_summary', { interval: 'hour', period: "#{limit} hours" }).map do |summary|
        Celo::BlocksSummary.new(summary)
      end
    end

    def validator_groups_count
      Rails.cache.fetch([self.class.name, 'validator_groups_count'].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        get_validator_groups.count
      end
    end

    private

    def get_validator_groups(height = nil)
      params = height ? { height: height } : {}
      get('/validator_groups', params)['items'] || []
    end
  end
end
