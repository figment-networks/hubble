module Near
  class Client < Common::IndexerClient
    # Get current service status
    def status
      Near::Status.new(get('/status'))
    end

    # Get current chain height
    def current_height
      get('/height')['height']
    end

    # Get the most recent block
    def current_block
      Near::Block.new(get('/block'))
    rescue Common::IndexerClient::NotFoundError
      nil
    end

    # Get block by hash or height
    def block(id)
      Near::Block.new(get("/blocks/#{id}"))
    rescue Common::IndexerClient::NotFoundError
      nil
    end

    alias block_by_hash block
    alias block_by_height block

    # Get block average times
    def block_times(limit = 100)
      Near::BlockTime.new(get('/block_times', limit: limit))
    end

    # Get block stats for a given time interval
    def block_stats_charts(opts = {})
      get_collection(Near::BlockStat, '/block_stats', opts)
    end

    def block_stats(period: '48', interval: 'h')
      get_collection(Near::BlockStat, '/block_stats', limit: period, bucket: interval)
    end

    # Get validators
    def validators
      get_collection(Near::Validator, '/validators')
    end

    # Get validator by hash or height
    def validator(id)
      data = get("/validators/#{id}")

      data['validator'].merge!(
        'account': data['account'],
        'epochs': data['epochs'],
        'blocks': data['blocks']
      )

      Near::Validator.new(data['validator'])
    end

    alias validator_by_height validator

    # Get account by name
    def account(id)
      Near::Account.new(get("/accounts/#{id}"))
    end

    def delegations(id)
      get_collection(Near::Delegation, "/delegations/#{id}")
    end
  end
end
