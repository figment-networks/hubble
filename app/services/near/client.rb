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

    # Get block times within a period
    def block_times_interval(period: '48', interval: 'h')
      get('/block_times_interval', period: period, interval: interval).map do |r|
        Near::IntervalStat.new(r)
      end
    end

    # Get validators
    def validators
      get('/validators').map { |v| Near::Validator.new(v) }
    end

    # Get validator by hash or height
    def validator(id)
      data = get("/validators/#{id}")
      Near::Validator.new(data['validator'].merge(
                            "account": data['account'],
                            "epochs": data['epochs'],
                            "blocks": data['blocks']
                          ))
    end

    alias validator_by_height validator

    # Get validator counts withing a period
    def validator_times_interval(period: '48', interval: 'h')
      get('/validator_times_interval', period: period, interval: interval).map do |r|
        Near::IntervalStat.new(r)
      end
    end

    # Get account by name
    def account(id)
      Near::Account.new(get("/accounts/#{id}"))
    end
  end
end
