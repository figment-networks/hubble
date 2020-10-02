require 'pathname'

class TaskLock
  RETRIES = 3
  WAIT_TIME = 5.seconds

  LOCKFILE_BASE = Rails.root.join('tmp', 'pids')
  LOCKFILES = {
    sync: File.join('task-lock--sync--{{ID}}.lock'),
    stats: File.join('task-lock--stats--{{ID}}.lock'),
    alerts: File.join('task-lock--alerts.lock'),
    digests: File.join('task-lock--digests.lock'),
    faucet: File.join('task-lock--faucet--{{ID}}.lock'),
    cleanup: File.join('task-lock--cleanup.lock')
  }.freeze

  class << self
    def with_lock!(name, id = nil, &block)
      return unless acquire_lock!(name, id)

      begin
        block.call
      ensure
        unlock!(name, id)
      end
    end

    def unlock!(name, id = nil)
      lockfiles = name ? [LOCKFILES[name]] : LOCKFILES.values
      lockfiles.map! do |path|
        path = path.sub '{{ID}}', id.to_s
        File.join(LOCKFILE_BASE, path)
      end
      FileUtils.rm_f lockfiles
    end

    private

    def acquire_lock!(name, id = nil)
      FileUtils.mkdir_p LOCKFILE_BASE
      lockfiles = name ? [LOCKFILES[name]] : LOCKFILES.values
      lockfiles.map! do |path|
        path = path.sub '{{ID}}', id.to_s
        File.join(LOCKFILE_BASE, path)
      end

      already_locked = !ENV['FORCE_LOCK'] && lockfiles.any? { |f| File.exist?(f) }

      tries = RETRIES
      if already_locked
        tries -= 1 while tries > 0 && lockfiles.any? { |f| File.exist?(f) }
        sleep WAIT_TIME
      end
      if tries == 0
        lockfile_location = Pathname.new(LOCKFILE_BASE).relative_path_from(Rails.root).to_s
        puts <<~MSG
          Bailing out, sync already running.
          Override: delete lockfiles in #{lockfile_location} or specify FORCE_LOCK=1:
          #{lockfiles.map { |f| "\t" + File.basename(f) }.join("\n")}
        MSG
        return false
      else
        FileUtils.touch lockfiles
        return true
      end
    end
  end
end
