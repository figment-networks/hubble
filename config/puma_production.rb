# Better to stick with number of cores available to keep the context switching to minimum.
workers Integer(ENV['WEB_CONCURRENCY'] || [1, `grep -c processor /proc/cpuinfo`.to_i].max)
threads_count = Integer(ENV['MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup DefaultRackup

# Socket interface, rather than HTTP for performance
bind 'unix:///opt/puma.sock'
environment ENV['RACK_ENV'] || 'production'

stdout_redirect(stdout = '/dev/stdout', stderr = '/dev/stderr', append = true)
