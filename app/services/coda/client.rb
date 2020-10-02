module Coda
  class Client < Common::IndexerClient
    # Get current service status
    def status
      Coda::Status.new(get('/status'))
    end

    # Get current chain height
    def current_height
      get('/height')['height']
    end

    # Get the most recent block
    def current_block
      Coda::Block.new(get('/block'))
    end

    # Get block by hash or height
    def block(id)
      Coda::BlockDetails.new(get("/blocks/#{id}"))
    end

    # Get last N blocks
    def blocks(limit: 50)
      get('/blocks', limit: limit).map do |block|
        Coda::Block.new(block)
      end
    end

    # Get block stats for a given interval and period
    def block_stats(period: 48, interval: 'h')
      get('/block_stats', period: period, interval: interval).map do |stat|
        Coda::BlockStat.new(stat)
      end
    end

    # Get block average times
    def block_times(limit = 100)
      Coda::BlockTime.new(get('/block_times', limit: limit))
    end

    # Get validators
    def validators
      get('/validators').map { |v| Coda::Validator.new(v) }
    end

    # Get validator details
    def validator(id)
      Coda::ValidatorDetails.new(get("/validators/#{id}"))
    end

    # Search transactions
    def transactions(params = {})
      get('/transactions', params).map { |t| Coda::Transaction.new(t) }
    end

    # Get transaction details
    def transaction(id)
      Coda::Transaction.new(get("/transactions/#{id}"))
    end

    # Get transaction stats for a given period of time
    def transactions_stats(period: 48, interval: 'h')
      get('/transactions_stats', period: period, interval: interval).map do |stat|
        Coda::TransactionStat.new(stat)
      end
    end

    # Get account details
    def account(id)
      Coda::Account.new(get("/accounts/#{id}"))
    end
  end
end
