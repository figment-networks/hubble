module TimeHelper
  SECONDS_PER_MINUTE = 60

  def seconds_in_minutes(seconds)
    seconds / SECONDS_PER_MINUTE.to_f
  end
end
