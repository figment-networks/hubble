module Oasis
  class Status < Common::Resource
    FRESH_TIME_LIMIT = 15.minutes

    field :app_name
    field :app_version
    field :go_version
    field :chain_app_version
    field :chain_block_version
    field :chain_id
    field :chain_name
    field :genesis_height
    field :genesis_time, type: :timestamp
    field :last_index_version
    field :last_indexed_height
    field :last_indexed_time, type: :timestamp
    field :last_indexed_at, type: :timestamp
    field :indexing_lag
    field :success

    alias success? success

    def initialize(attributes = {})
      attributes['success'] = true if attributes['success'].nil?
      super(attributes)
    end

    def self.failed
      new({ 'success' => false })
    end

    def stale?
      last_indexed_time < FRESH_TIME_LIMIT.ago
    end

    def status
      stale? ? 'STALE' : 'OK'
    end
  end
end
