class Avalanche::StatsChartDecorator < SimpleDelegator
  def initialize(stats)
    @stats = stats.reverse
  end

  def validator_chart_info
    @stats.map do |stat|
      { t: stat.time.to_time, y: stat.active_validators }
    end
  end

  def delegations_chart_info
    @stats.map do |stat|
      { t: stat.time.iso8601, y: stat.active_delegations }
    end
  end
end
