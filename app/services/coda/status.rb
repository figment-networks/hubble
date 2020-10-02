module Coda
  class Status < Resource
    STATUS_CURRENT = 'current'.freeze
    STATUS_STALE   = 'stale'.freeze

    field :app_name
    field :app_version
    field :sync_status
    field :git_commit
    field :go_version
    field :last_block_height
    field :last_block_time, type: :timestamp

    def stale?
      sync_status != STATUS_CURRENT
    end
  end
end
