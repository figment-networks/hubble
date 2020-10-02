require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require "action_cable/engine"
require 'sprockets/railtie'
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

class ActionController::NotFound < StandardError; end
class ActionController::Deleted < StandardError; end
class ActionController::Denied < StandardError; end

module Hubble
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.action_dispatch.rescue_responses['ActionController::Deleted'] = :not_found
    config.action_dispatch.rescue_responses['ActionController::NotFound'] = :not_found
    config.action_dispatch.rescue_responses['ActionController::Denied'] = :forbidden

    # Fixes AR deprecation
    config.active_record.sqlite3.represent_boolean_as_integer = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.middleware.use Rack::Attack
    # Needed to capture the /404's that don't get passed straight to the controller (e.g. cosmoslike chains that don't use governance)
    config.exceptions_app = routes
  end
end
