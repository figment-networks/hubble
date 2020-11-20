class Common::ChartDecorator < SimpleDelegator
  def point
    { t: time_bucket.to_time, y: total }
  end
end
