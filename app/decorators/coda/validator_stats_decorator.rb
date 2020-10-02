class Coda::ValidatorStatsDecorator < SimpleDelegator
  include FormattingHelper

  def initialize(chain, stats)
    @chain = chain
    @stats = stats.reverse
  end

  def balance_chart_data
    @stats.map do |s|
      { t: s.time.iso8601, y: amount(s.delegations_amount) }
    end
  end

  def blocks_chart_data
    @stats.map do |s|
      { t: s.time.iso8601, y: s.blocks_produced_count }
    end
  end

  private

  def amount(val)
    format_amount(val,
                  denom: 'coda',
                  html: false,
                  hide_units: true).sub(',', '').to_f
  end
end
