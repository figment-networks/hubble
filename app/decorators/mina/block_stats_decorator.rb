class Mina::BlockStatsDecorator < SimpleDelegator
  def initialize(chain, stats)
    @chain = chain
    @stats = stats.reverse
  end

  def blocks_chart_data
    @stats.map do |s|
      { t: s.time.iso8601, y: s.block_minutes_avg }
    end
  end

  def validators_chart_data
    @stats.map do |s|
      { t: s.time.iso8601, y: s.validators_count }
    end
  end
end
