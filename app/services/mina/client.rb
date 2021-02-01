module Mina
  class Client < Common::IndexerClient
    # Get current service status
    def status
      Mina::Status.new(get('/status'))
    end

    # Get current chain height
    def current_height
      get('/height')['height']
    end

    # Get the most recent block
    def current_block
      Mina::Block.new(get('/block'))
    end

    # Get block by hash or height
    def block(id)
      Mina::BlockDetails.new(get("/blocks/#{id}"))
    end

    # Get last N blocks
    def blocks(limit: 50)
      get('/blocks', limit: limit).map do |block|
        Mina::Block.new(block)
      end
    end

    # Get block stats for a given interval and period
    def block_stats(period: 48, interval: 'h')
      get('/block_stats', period: period, interval: interval).map do |stat|
        Mina::BlockStat.new(stat)
      end
    end

    # Get block average times
    def block_times(limit = 100)
      Mina::BlockTime.new(get('/block_times', limit: limit))
    end

    # Get validators
    def validators
      get('/validators').map { |v| Mina::Validator.new(v) }
    end

    # Get validator details
    def validator(id)
      Mina::ValidatorDetails.new(get("/validators/#{id}"))
    end

    # Search transactions
    def transactions(params = {})
      get('/transactions', params).map { |t| Mina::Transaction.new(t) }
    end

    # Get transaction details
    def transaction(id)
      Mina::Transaction.new(get("/transactions/#{id}"))
    end

    # Get transaction stats for a given period of time
    def transactions_stats(period: 48, interval: 'h')
      get('/transactions_stats', period: period, interval: interval).map do |stat|
        Mina::TransactionStat.new(stat)
      end
    end

    # Get account details
    def account(id)
      Mina::Account.new(get("/accounts/#{id}"))
    end
  end
end
