module Celo
  class Status < Common::Resource
    field :last_indexed_height, type: :integer
    field :last_indexed_time, type: :timestamp
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

    def self.failed
      new({ 'success' => false })
    end
  end
end
