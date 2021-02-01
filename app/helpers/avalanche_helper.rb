module AvalancheHelper
  def avalanche_chain_dashboard_path(*_args)
    avalanche_root_path
  end

  def remaining_time(time)
    time_ago_in_words(time).split(',').first.split(' and ').first
  end

  def capacity_remaining(capacity_percent)
    (100 - capacity_percent).round(2)
  end
end
