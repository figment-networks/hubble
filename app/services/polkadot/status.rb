module Polkadot
  class Status < Common::Resource
    field :last_indexed_height, type: :integer
    field :last_indexed_time, type: :timestamp
    field :last_indexed_era_height, type: :integer
    field :last_indexed_session_height, type: :integer
    field :app_version
    field :go_version
    field :success

    def initialize(attributes = {})
      super(attributes)
      @success = true if @success.nil?
    end

    alias last_block_height last_indexed_height
    alias last_block_time last_indexed_time
    alias success? success

    def indexed_validators_height
      last_indexed_era_height - 1
    end

    def self.failed
      new({ 'success' => false })
    end
  end
end
