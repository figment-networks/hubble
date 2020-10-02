module Near
  class Status < Common::Resource
    STATUS_CURRENT = 'current'.freeze
    STATUS_STALE   = 'stale'.freeze

    field :app_name
    field :app_version
    field :git_commit
    field :go_version
    field :last_block_height
    field :last_block_time, type: :timestamp
    field :sync_status

    def stale?
      sync_status != STATUS_CURRENT
    end
  end
end
