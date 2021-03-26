source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'bootsnap', require: false
gem 'jbuilder', '~> 2.5'
gem 'pg', '>= 0.18', '< 2.0'
gem 'rails', '~> 5.2'
gem 'sass-rails', '~> 5.0'
gem 'webpacker', '~>5.2'

gem 'actionmailer_inline_css'
gem 'babel-transpiler'

gem 'acts_as_list'
gem 'addressable'
gem 'attr_encrypted', '~> 3.0.0'
gem 'bcrypt'
gem 'chartkick'
gem 'counter_culture', '~> 2.0'
gem 'cryptocompare'
gem 'curb'
gem 'dalli'
gem 'dotiw'
gem 'local_time'
gem 'pagy', '~> 3.5'
gem 'puma'
gem 'redcarpet'
gem 'rest-client'
gem 'rinku'
gem 'suo'
gem 'useragent'

gem 'postmark-rails'
gem 'twitter', '~> 6.1.0'

# used for notifing when Chains are out of sync
gem 'slack-notifier'

# temp, used for uploading reports to s3
gem 'aws-sdk-s3', '~> 1'
gem 'sqlite3'

# admin session management
gem 'active_model_otp', '~> 1.2.0'
gem 'rqrcode', '~> 0.10.1'

gem 'bip_mnemonic' # bip39
gem 'bitcoin-ruby', require: 'bitcoin' # bech32
gem 'bitcoin-secp256k1', require: 'secp256k1'
gem 'money-tree', require: false # bip32

gem 'lograge'
gem 'rack-attack'
gem 'rack-revision'
gem 'rollbar'
gem 'whenever', require: false

gem 'bootstrap_form', '~> 4.3.0'
gem 'gqli', '~> 1.0.0'
gem 'rash_alt', '~> 0.4.8', require: 'rash'
gem 'validate_url', '~> 1.0.8'

# Prime
gem 'apexcharts'
gem 'groupdate'
gem 'jquery-ui-rails'

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'

  # Deployment
  gem 'capistrano', '~> 3.11', require: false
  gem 'capistrano-linked-files', require: false
  gem 'capistrano-npm', require: false
  gem 'capistrano-rails', '~> 1.4', require: false
  gem 'capistrano-slackify', '~> 2.10.3', require: false
end

group :development, :test do
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'guard-rspec'
  gem 'letter_opener_web', '~> 1.0'
  gem 'parallel_tests'
  gem 'pry'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'rubocop'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara', '~> 3.33'
  gem 'database_cleaner'
  gem 'factory_bot_rails', '~> 5.1.1'
  gem 'rails-controller-testing'
  gem 'rspec-retry', '>= 0.6.2'
  gem 'selenium-webdriver', '~> 3.142'
  gem 'vcr', '~> 6.0'
  gem 'webdrivers', '~> 4.3'
  gem 'webmock', '~> 3.11'
end

group :production do
  gem 'unicorn'
end
