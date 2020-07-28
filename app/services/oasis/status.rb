module Oasis
  class Status < Common::Resource

    FRESH_TIME_LIMIT = 15.minutes

    attr_accessor :app_name,
                  :app_version,
                  :go_version,
                  :chain_app_version,
                  :chain_block_version,
                  :chain_id,
                  :chain_name,
                  :genesis_height,
                  :genesis_time,
                  :last_index_version,
                  :last_indexed_height,
                  :last_indexed_time,
                  :last_indexed_at,
                  :indexing_lag

    def initialize(attrs = {})
      super(attrs)
      @genesis_time = Time.zone.parse(genesis_time)
      @last_indexed_time = Time.zone.parse(last_indexed_time)
      @last_indexed_at = Time.zone.parse(last_indexed_at)
    end

    def status
      (Time.current - last_indexed_time) <= FRESH_TIME_LIMIT ? "OK" : "STALE"
    end
  end
end
