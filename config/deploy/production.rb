server ENV['DEPLOY_HOST'], user: 'root', roles: %w{ app db web }
set :ssh_options, {
  keys: ENV['DEPLOY_KEYS'].split(','),
  forward_agent: true
}

set :rails_env, 'production'
set :branch, 'master'
