rails_env = ENV['RACK_ENV'] || ENV['RAILS_ENV'] or raise "Specify Rails environment!"

app_root = "/home/hubble/app"
working_directory "#{app_root}/current"

pid "#{app_root}/shared/tmp/pids/unicorn.pid"
stderr_path "#{app_root}/shared/log/unicorn.log"
stdout_path "#{app_root}/shared/log/unicorn.log"

# number of workers (+1 master)
num_workers = rails_env == 'production' ? 8 : 1
worker_processes num_workers

user 'hubble', 'hubble'

# Load app into the master before forking workers
preload_app true

# Restart any workers that haven't responded in 2 minutes
# saving blocks can sometimes be slow on some people's connections
timeout 120

# Listen on a Unix data socket
listen "/tmp/hubble2-unicorn.sock", backlog: 4096

before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{app_root}/current/Gemfile"
end

before_fork do |server, worker|
  # master does not need db connection
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)

  # preload fucking i18n translations ffs
  I18n.t('activerecord')

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      # decrement worker count of old master
      # until final new worker starts, then kill old master
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # that's cool
    end
  end
  sleep 0.5
end

after_fork do |server, worker|
  ##
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection
  ActiveRecord::Base.establish_connection
  # QC.default_conn_adapter = QC::ConnAdapter.new(ActiveRecord::Base.connection.raw_connection)

  # one more time make damn sure we have preloaded i18n omg
  I18n.t('activerecord')
end
