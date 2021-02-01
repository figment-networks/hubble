class Avalanche::UptimeChartDecorator < SimpleDelegator
  def point
    { t: time.to_time, y: uptime_avg }
  end
end
