require 'shellwords'
require 'securerandom'

module CapybaraHelpers
  def screenshot
    save_path = "/tmp/capybara-#{SecureRandom.uuid}.png"
    save_screenshot(save_path, full: true)

    case `uname -s`.strip.downcase
    when 'darwin'
      system("open #{Shellwords.escape(save_path)}")
    else
      save_and_open_screenshot
    end
  end
end
