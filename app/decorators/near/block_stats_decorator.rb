class Near::BlockStatsDecorator < SimpleDelegator
  def initialize(stats)
    @stats = stats.reverse
  end

  def chart_data
    @stats.map do |s|
      { t: s.time.iso8601, y: s.block_time_avg }
    end
  end
end
