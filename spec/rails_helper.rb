ENV['TZ'] ||= 'UTC'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

require 'spec_helper'
require 'rspec/rails'
require 'webmock/rspec'
require 'vcr'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

WebMock.disable_net_connect!(allow_localhost: true)

VCR.configure do |config|
  config.cassette_library_dir = "spec/support/vcr_cassettes"
  config.hook_into(:webmock)
  config.allow_http_connections_when_no_cassette = false
  config.configure_rspec_metadata!
  config.debug_logger = File.open('./log/vcr.log', 'w')
  config.ignore_hosts('127.0.0.1', 'chromedriver.storage.googleapis.com')
  config.before_record { |i| i.response.body.force_encoding('UTF-8') }
end

RSpec.configure do |config|
  config.use_transactional_fixtures = true

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include ActiveSupport::Testing::TimeHelpers
  config.include FactoryBot::Syntax::Methods

  config.include FixtureHelpers
  config.include IndexerApiHelpers
  config.include SessionHelpers, type: :feature

  config.include Livepeer::GraphHelpers, livepeer: :graph
  config.include Livepeer::FactoryHelpers, livepeer: :factory
end
