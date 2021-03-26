require 'rails_helper'
require 'capybara/rspec'
require 'rspec/retry'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome)
end

Capybara.register_driver :headless_chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  chrome_options = ['--headless', '--window-size=1280x720', '--disable-gpu', '--no-sandbox']
  chrome_options.each { |arg| options.add_argument(arg) }

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.configure do |config|
  config.default_driver = :headless_chrome
  config.javascript_driver = :headless_chrome
  config.server = :puma, { Silent: true }
  config.server_port = 9887 + ENV['TEST_ENV_NUMBER'].to_i

  config.automatic_label_click = true
end

RSpec.configure do |config|
  config.verbose_retry = true
  config.display_try_failure_messages = true
  config.exceptions_to_retry = [Net::ReadTimeout]
end
