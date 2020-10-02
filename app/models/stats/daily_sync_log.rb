class Stats::DailySyncLog < ApplicationRecord
  belongs_to :chainlike, polymorphic: true
  default_scope -> { order('date DESC') }

  def total_blocks
    if end_height && start_height
      end_height - start_height
    end
  end

  def timestamp
    date
  end

  class << self
    def build_from(logs)
      total_logs = logs.count
      return nil if total_logs == 0

      start_time = logs.first.started_at.beginning_of_day
      succeeded = logs.select(&:completed_at)
      failed = logs.select(&:failed_at)
      new(
        chainlike: logs.first.chainlike,
        date: start_time,
        sync_count: total_logs,
        fail_count: failed.count,
        total_sync_time: logs.sum(&:duration),
        start_height: succeeded.map(&:start_height).min,
        end_height: succeeded.map(&:end_height).max
      )
    end

    def create_from(logs)
      total_logs = logs.count
      daily = build_from(logs)
      if daily.valid? && daily.save
        Stats::SyncLog.where(id: logs.map(&:id)).delete_all
        puts "\tCreated #{daily.date} sync log bucket and deleted #{total_logs} minutelies."
      end
    end
  end
end
