namespace :sync do
  task :all do
    %w[cosmos terra iris kava emoney livepeer].each do |network|
      Rake::Task["sync:#{network}"].invoke
    end
  end

  %w[cosmos terra iris kava emoney].each do |network|
    task "#{network.to_sym}": :environment do
      $stdout.sync = true
      puts "\nStarting sync:#{network} task at #{Time.now.utc.strftime(TASK_DATETIME_FORMAT)}"
      network.titleize.constantize::Chain.enabled.find_each do |chain|
        TaskLock.with_lock!(:sync, "#{network}-#{chain.ext_id}") do
          log = Stats::SyncLog.start(chain)

          begin
            bss = chain.namespace::BlockSyncService.new(chain)
            log.set_status 'blocks'
            bss.sync!
          rescue StandardError
            log.report_error $!
            log.end && next if $!.is_a?(chain.namespace::SyncBase::CriticalError)

            puts "Failed to complete block sync!\n#{$!.message}"
            puts $!.backtrace.join("\n") && puts if ENV['DEBUG']
          end

          begin
            log.set_status 'governance'
            gss = chain.namespace::GovSyncService.new(chain)
            gss.sync_params!
            gss.sync_pool!
            gss.sync_proposals!
            gss.sync_token_stats!
          rescue StandardError
            log.report_error $!
            log.end && next if $!.is_a?(chain.namespace::SyncBase::CriticalError)

            puts "Failed to complete governance sync!\n#{$!.message}"
            puts $!.backtrace.join("\n") && puts if ENV['DEBUG']
          end

          begin
            log.set_status 'halt-check'
            hcs = chain.namespace::HaltedChainService.new(chain)
            hcs.check_for_halted_chain!
          rescue StandardError
            log.report_error $!
            log.end && next if $!.is_a?(chain.namespace::SyncBase::CriticalError)

            puts "Failed to complete halt check!\n#{$!.message}"
            puts $!.backtrace.join("\n") && puts if ENV['DEBUG']
          end

          if !chain.halted?
            begin
              log.set_status 'validators'
              vss = chain.namespace::ValidatorSyncService.new(chain)
              vss.sync_validator_timestamps!
              vss.sync_validator_metadata!
              vss.update_history_height!
            rescue StandardError
              log.report_error $!
              log.end && next if $!.is_a?(chain.namespace::SyncBase::CriticalError)

              puts "Failed to complete validator sync!\n#{$!.message}"
              puts $!.backtrace.join("\n") && puts if ENV['DEBUG']
            end
          end

          begin
            log.set_status 'validator-events'
            ves = chain.namespace::ValidatorEventsService.new(chain)
            ves.run!
          rescue StandardError
            log.report_error $!
            log.end && next if $!.is_a?(chain.namespace::SyncBase::CriticalError)

            puts "Failed to complete events sync!\n#{$!.message}"
            puts $!.backtrace.join("\n") && puts if ENV['DEBUG']
          end

          begin
            log.set_status 'stats'
            stats = chain.namespace::AverageSnapshotsGeneratorService.new(chain)
            stats.generate_block_time_snapshots!
            stats.generate_voting_power_snapshots!
            stats.generate_validator_uptime_snapshots!
            stats.generate_active_validators_snapshots!
          rescue StandardError
            log.report_error $!
            log.end
            puts "Failed to collect stats!\n#{$!.message}"
            puts $!.backtrace.join("\n") && puts if ENV['DEBUG']
          end

          begin
            log.set_status 'cleanup'
            bss.cleanup!
          rescue StandardError
            log.report_error $!
            log.end
            puts "Failed to complete block cleanup!\n#{$!.message}"
            puts $!.backtrace.join("\n") && puts if ENV['DEBUG']
          end

          log.set_status 'done'
          log.end
        end
      end
      puts "Completed sync:#{network} task at #{Time.now.utc.strftime(TASK_DATETIME_FORMAT)}\n\n"
    end
  end

  task livepeer: :environment do
    $stdout.sync = true

    Livepeer::Chain.enabled.find_each do |chain|
      TaskLock.with_lock!(:sync, "livepeer-#{chain.slug}") do
        Livepeer::ChainSyncService.new(chain).call
      end
    end
  end
end
