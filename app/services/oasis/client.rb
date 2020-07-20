module Oasis
  class Client
    DEFAULT_TIMEOUT = 5

    class Error < StandardError; end

    def initialize(endpoint, options = {})
      @endpoint = endpoint
      @timeout = options[:timeout] || DEFAULT_TIMEOUT
    end

    def status
      Oasis::Status.new(get("/status"))
    end

    def current_block
      Oasis::Block.new(get("/block"))
    end

    def block(id)
      Oasis::Block.new(get("/block", height: id))
    end

    def block_times(limit = 100)
      Oasis::BlockTime.new(get("/block_times/#{limit}"))
    end

    def blocks_summary(interval = "hour", period = "48 hours")
      get("/blocks_summary", period: period, interval: interval).map do |point|
        Oasis::IntervalStat.new(point)
      end
    end

    def staking(height)
      Oasis::Staking.new(get("/staking", height: height))
    end

    def validators
      get("/validators/for_min_height/1")['items'].map do |val|
        Oasis::Validator.new(val)
      end
    end

    def validator(address, limit = 0)
      Oasis::Validator.new(get("/validator/#{address}", sequences_limit: limit))
    end

    def validators_by_height(height)
      get("/validators", height: height)['items'].map do |val|
        Oasis::Validator.new(val)
      end
    end

    def validators_summary(interval = "hour", period = "48 hours", entity_uid = nil)
      get("/validators_summary", period: period, interval: interval, entity_uid: entity_uid).map do |point|
        Oasis::IntervalStat.new(point)
      end
    end

    def transactions(height)
      list = get("/transactions", height: height)['items']
      if list.nil?
        return []
      end

      list.map do |transaction|
        Oasis::Transaction.new(transaction)
      end
    end

    def transaction(height, public_key)
      list = get("/transactions", height: height)['items']
      list.each do |transaction|
        if transaction['public_key'] == public_key
          return Oasis::Transaction.new(transaction)
        end
      end
      return nil
    end

    private

    def get(path, params = {})
      resp = RestClient::Request.execute(
        method: :get,
        url: "#{@endpoint}#{path}",
        headers: { params: params },
        timeout: @timeout
      )
      JSON.load(resp.body)
    rescue StandardError => err
      raise Oasis::Client::Error, err
    end
  end
end
