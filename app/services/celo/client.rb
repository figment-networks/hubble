module Celo
  class Client < Common::IndexerClient
    DEFAULT_BLOCK_HOURS = 48
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
        Celo::Block.new(get('/block/by_height', height: height))
      end
    end

    def account(address)
      # guessing this endpoint should be called `/account/by_account`? Let's see how production indexer looks like
      Celo::Account.new(get('/account/by_height', address: address))
    end

    def account_details(address)
      Rails.cache.fetch([self.class.name, 'account_details', address].join('-'), expires_in: SHORT_EXPIRY_TIME) do
        raw_account_details = get("/account/details/#{address}")
        # TODO: most probably this will include more fields than internal_transfers_sent, fix with a real indexer
        transfers = raw_account_details['internal_transfers_sent'].map { |transfer| transfer.merge(transfer['data']) }
        transactions = raw_account_details.slice(*ACCOUNT_TRANSACTIONS_KEYS).values.flatten.map { |transfer| transfer.merge(transfer['data']) }
        Celo::AccountDetails.new(raw_account_details.merge(transfers: transfers, transactions: transactions))
      end
    end

    def transactions(height)
      raw_transactions = get('/transactions/by_height', height: height)
      raw_transactions['items'].map do |transaction|
        transfers = transaction['operations'].map do |operation|
          # ignore other operation types for now
          next if operation['details']['type'] != 'transfer'

          operation.merge(operation['details']).merge(
            transaction_hash: transaction['hash'],
            height: transaction['height'],
            kind: operation['name']
          )
        end
        Celo::Transaction.new(transaction.merge(transfers: transfers))
      end
    end

    def transaction(height, transaction_id)
      # TODO: remove `|| transactions(height)` when switching to a real indexer
      transactions(height).find { |transaction| transaction.hash == transaction_id } || transactions(height).first
    end

    def validator_groups(height = DEFAULT_LATEST_HEIGHT)
      Rails.cache.fetch([self.class.name, 'validator_groups', height].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        get_validator_groups(height).map do |validator_group|
          Celo::ValidatorGroup.new(validator_group)
        end
      end
    end

    def validator(_address)
      raw_validator = get('/validator/details')
      validator = Celo::Validator.new(raw_validator.merge(raw_validator['last_sequences'].first))
      validator.tap { |validator| validator.validator_group = validator_group(validator.affiliation) }
    end

    def validators(address)
      get('/validators/by_height')['items'].
        select { |validator| validator['affiliation'] == address }.
        map { |validator| Celo::Validator.new(validator) }
    end

    # TODO: params
    def validator_group(_address)
      validator_group = get('/validator_group/details')
      Celo::ValidatorGroup.new(validator_group.merge(validator_group['last_sequences'].first))
    end

    # TODO: params -> daily, 90 days etc
    def validator_groups_summary
      groups_count = validator_groups_count
      get('/validator_groups/summary_hourly').map do |summary|
        Celo::ValidatorGroupsSummary.new(summary.merge('validator_groups_count' => groups_count))
      end
    end

    # TODO: we don't have mocks for daily score
    def validator_daily_score(_address)
      get('/validators/summary_hourly').map do |summary|
        Celo::ValidatorSummary.new(summary)
      end
    end

    def validator_hourly_uptime(_address)
      get('/validators/summary_hourly').map do |summary|
        Celo::ValidatorSummary.new(summary)
      end
    end

    def blocks_summary(limit = DEFAULT_BLOCK_HOURS)
      get('/block/summary_hourly', params: { interval: 'hour', period: "#{limit} hours" }).map do |summary|
        Celo::BlocksSummary.new(summary)
      end
    end

    def validator_groups_count
      Rails.cache.fetch([self.class.name, 'validator_groups_count'].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        get_validator_groups.count
      end
    end

    private

    def get_validator_groups(height = DEFAULT_LATEST_HEIGHT)
      get('/validator_groups/by_height', height: height)['items']
    end
  end
end
