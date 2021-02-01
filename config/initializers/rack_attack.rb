# banned for scraping /cosmos/hubble/gaia-8001/validators/0A692DBFFE9E5DD28E7DECC33CED1AEB4C0D014E
Rack::Attack.blocklist_ip('54.180.21.34')

# banned for scraping /cosmos/hubble/gaia-8001/validators/E50ADECD5FD27FA2CD610C07F8AED36A2FC4A6A6
Rack::Attack.blocklist_ip('18.222.83.36')

# banned for scraping /chains/cosmoshub-1/validators/4E9CB39F4B1FA617339744A5600B62802652D69C
Rack::Attack.blocklist_ip('35.236.88.114')

# banned for scraping /chains/cosmoshub-1/validators/2B19594437F1920B5AF6461FAB81AEC99790FEB1
Rack::Attack.blocklist_ip('104.196.140.13')

# https://rollbar.com/figment-networks/Hubble/items/4894/?item_page=2&item_count=100&#instances
Rack::Attack.blocklist_ip('34.227.74.141')

Rack::Attack.throttle('faucet requests by ip', limit: 10, period: 2.hours.to_i) do |request|
  if request.path.ends_with?('/faucet/transactions') && request.post?
    request.ip
  end
end

Rack::Attack.throttle('requests by ip', limit: 150, period: 5.minutes.to_i) do |request|
  request.ip unless request.path.start_with?('/assets')
end

Rack::Attack.blocklist('block UA by partial bot names match') do |request|
  %w[AhrefsBot
     BLEXBot
     PetalBot
     SemrushBot
     Applebot
     YandexBot
     MJ12bot
     CCBot].any? { |bot_name| request.user_agent&.include?(bot_name) }
end

Rack::Attack.blocklist('block curl requests') do |request|
  request.user_agent&.starts_with?('curl(')
end
