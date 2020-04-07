TASK_DATETIME_FORMAT = '%Y-%m-%d %H:%M:%S %Z'
ALERT_MINIMUM_TIMEOUT = 15.minutes

PETA = (10 ** 15).to_f
TERA = (10 ** 12).to_f
GIGA = (10 ** 9).to_f
MEGA = (10 ** 6).to_f
KILO = (10 ** 3).to_f

MILLI = (10 ** -3).to_f
MICRO = (10 ** -6).to_f
NANO  = (10 ** -9).to_f
PICO  = (10 ** -12).to_f
FEMTO = (10 ** -15).to_f
ATTO  = (10 ** -18).to_f

REQUIRE_HTTP_BASIC = if !Rails.application.secrets.http_basic_password.blank?
  HTTP_BASIC_USERNAME = 'hubble'
  HTTP_BASIC_PASSWORD = Rails.application.credentials.http_basic_password
  true
else
  false
end
