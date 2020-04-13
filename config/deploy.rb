# config valid for current version and patch releases of Capistrano
lock '~> 3.11.0'

set :application, 'hubble'
set :repo_url, 'https://github.com/figment-networks/hubble'

# Default branch is :master
set :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/hubble/app'

# Default value for :linked_files is []
before 'deploy:check:linked_files', 'linked_files:upload_files'
append :linked_files, 'config/database.yml', 'config/secrets.yml.enc', 'config/secrets.yml.key'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'public/system'

set :npm_flags, '--production --silent --no-progress'

# Default value for default_env is {}
set :default_env, { path: '/hubble/ruby-2.5.0/bin:/hubble/node-8.12/bin:$PATH' }

# Default value for local_user is ENV['USER']
set :local_user, -> { ENV['DEPLOY_USER'] } if ENV['DEPLOY_USER']

set :keep_releases, 2
set :keep_assets, 2

task :restart_web do
  on roles(:web) do
    execute "sudo systemctl reload hubble-unicorn-#{fetch(:rails_env)}"
  end
end

if !ENV.has_key?('NO_RESTART')
  after 'deploy:symlink:release', :restart_web
end

namespace :syncing do
  task :suspend do
    on roles(:cron) do
      execute 'sudo systemctl stop cron'
    end
  end

  task :resume do
    on roles(:cron) do
      execute 'sudo systemctl start cron'
    end
  end
end
