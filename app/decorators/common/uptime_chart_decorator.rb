class Common::UptimeChartDecorator < SimpleDelegator
  def point
    { t: time_bucket.to_time, y: uptime_avg * 100 }
  end
end
