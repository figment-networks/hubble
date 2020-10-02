if !Rails.env.development?
  Rails.application.configure do
    if defined?(Rails::Console)
      config.logger = Logger.new('/dev/null')
      config.after_initialize { ActiveRecord::Base.logger.level = 0 }
    else
      config.log_formatter = Logger::Formatter.new
      config.lograge.enabled = true
      config.lograge.custom_options = lambda do |event|
        ua = UserAgent.parse(event.payload[:user_agent]).as_json.first rescue nil
        ua_str = "#{ua['product']}(#{ua['version']['str']})" rescue 'unknown'

        {
          time: Time.now.strftime('%Y-%m-%d%H:%M:%S%Z'),
          ua: ua_str,
          user_id: event.payload[:uid],
          admin_id: event.payload[:aid]
        }
      end
    end
  end
end
