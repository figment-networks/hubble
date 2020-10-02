module Oasis
  class Block < Common::Resource
    FRESH_TIME_LIMIT = 15.minutes

    field :app_version
    field :block_version
    field :chain_id
    field :height, type: :integer
    field :time, type: :timestamp
    field :last_block_id_hash
    field :last_commit_hash
    field :data_hash
    field :validators_hash
    field :next_validators_hash
    field :consensus_hash
    field :app_hash
    field :last_results_hash
    field :evidence_hash
    field :proposer_address

    def self.failed(height)
      new(last_block_id_hash: height)
    end

    def status
      (Time.current - time) <= FRESH_TIME_LIMIT ? 'OK' : 'STALE'
    end
  end
end
