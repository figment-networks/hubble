module Celo
  class Client < Common::IndexerClient
    DEFAULT_BLOCK_HOURS = 48

    def status
      @status ||= Celo::Status.new(get('/status'))
    rescue Common::IndexerClient::Error
      Celo::Status.failed
    end

    def validator_groups(height = DEFAULT_LATEST_HEIGHT)
      Rails.cache.fetch([self.class.name, 'validator_groups', height].join('-'), expires_in: MEDIUM_EXPIRY_TIME) do
        get_validator_groups(height).map do |validator_group|
          Celo::ValidatorGroup.new(validator_group)
        end
      end
    end

    # TODO: params -> daily, 90 days etc
    def validator_groups_summary
      groups_count = validator_groups_count
      get('/validator_groups/summary_hourly').map do |summary|
        Celo::ValidatorGroupsSummary.new(summary.merge('validator_groups_count' => groups_count))
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
