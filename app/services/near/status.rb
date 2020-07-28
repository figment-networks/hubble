module Near
  class Status < Common::Resource
    STATUS_CURRENT = "current"
    STATUS_STALE   = "stale"

    attr_accessor :app_name,
                  :app_version,
                  :git_commit,
                  :go_version,
                  :last_block_height,
                  :last_block_time,
                  :sync_status

    def initialize(attrs = {})
      super(attrs)

      @last_block_time = Time.zone.parse(last_block_time)
    end

    def stale?
      sync_status != STATUS_CURRENT
    end
  end
end
