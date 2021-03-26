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
      get_collection(Mina::Block, '/blocks', limit: limit)
    end

    # Get block stats for a given interval and period
    def block_stats(period: 48, interval: 'h')
      get_collection(Mina::BlockStat, '/block_stats', period: period, interval: interval)
    end

    # Get block average times
    def block_times(limit = 100)
      Mina::BlockTime.new(get('/block_times', limit: limit))
    end

    # Get validators
    def validators
      get_collection(Mina::Validator, '/validators')
    end

    # Get validator details
    def validator(id)
      Mina::ValidatorDetails.new(get("/validators/#{id}"))
    end

    # Search transactions
    def transactions(params = {})
      get_collection(Mina::Transaction, '/transactions', params)
    end

    # Get transaction details
    def transaction(id)
      Mina::Transaction.new(get("/transactions/#{id}"))
    end

    # Get account details
    def account(id)
      Mina::Account.new(get("/accounts/#{id}"))
    end

    def delegations(public_key: nil, delegate: nil)
      get_collection(Mina::Account, '/delegations', { public_key: public_key, delegate: delegate })
    end
  end
end
