module Oasis
  class Block < Common::Resource

    FRESH_TIME_LIMIT = 15.minutes

    attr_accessor :app_version,
                  :block_version,
                  :chain_id,
                  :height,
                  :time,
                  :last_block_id_hash,
                  :last_commit_hash,
                  :data_hash,
                  :validators_hash,
                  :next_validators_hash,
                  :consensus_hash,
                  :app_hash,
                  :last_results_hash,
                  :evidence_hash,
                  :proposer_address

    def initialize(attrs = {})
      super(attrs)
      @time = Time.zone.parse(time)
    end

    def status
      (Time.current - time) <= FRESH_TIME_LIMIT ? "OK" : "STALE"
    end
  end
end
