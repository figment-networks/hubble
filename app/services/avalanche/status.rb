module Avalanche
  class Status < Common::Resource
    field :app_version
    field :go_version
    field :success
    field :sync_time, type: :timestamp

    def initialize(attributes = {})
      super(attributes)
      @success = true if @success.nil?
    end

    alias success? success

    def self.failed
      new({ 'success' => false })
    end
  end
end
