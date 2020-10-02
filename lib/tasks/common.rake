namespace :common do
  namespace :logs do
    task clean_dailies: :environment do
      $stdout.sync = true
      TaskLock.with_lock!(:cleanup) do
        puts "Starting daily sync log cleaning task at #{Time.now.utc.strftime(TASK_DATETIME_FORMAT)}"
        to_clean = Stats::SyncLog.last
        while to_clean && to_clean.started_at < Time.now.utc.beginning_of_day
          # bucket all other synclogs from that day
          start_time = to_clean.started_at.beginning_of_day
          end_time = to_clean.started_at.end_of_day

          puts "TO CLEAN: #{start_time}"

          bucket = Stats::SyncLog.where(
            'started_at >= ? AND started_at <= ?',
            start_time, end_time
          ).group_by { |sl| sl.chainlike }

          bucket.keys.each do |chain|
            Stats::DailySyncLog.create_from bucket[chain]
          end

          to_clean = Stats::SyncLog.where('started_at > ?', end_time).last
        end
        puts "Completed daily sync log cleaning task at #{Time.now.utc.strftime(TASK_DATETIME_FORMAT)}\n\n"
      end
    end
  end

  namespace :alerts do
    namespace :users do
      task instant: :environment do
        $stdout.sync = true
        TaskLock.with_lock!(:alerts) do
          Common::AlertSubscriptionNotifier.new(:instant).run!
        end
      end

      task daily: :environment do
        $stdout.sync = true
        TaskLock.with_lock!(:digests) do
          date = Time.parse(ENV['DIGEST_DATE']) if ENV['DIGEST_DATE']
          date ||= 1.day.ago # yesterday by default
          Common::AlertSubscriptionNotifier.new(:daily, date).run!
        end
      end
    end
  end
end
