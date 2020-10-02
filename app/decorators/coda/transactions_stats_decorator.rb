class Coda::TransactionsStatsDecorator < SimpleDelegator
  include FormattingHelper

  def initialize(chain, stats)
    @chain = chain
    @stats = stats.reverse
  end

  def payments_chart_data
    serialize(:payments_amount)
  end

  def fees_chart_data
    serialize(:fees_amount)
  end

  def work_fees_chart_data
    serialize(:snark_fees_amount)
  end

  private

  def serialize(key)
    @stats.map do |s|
      { t: s.time.iso8601, y: amount(s.send(key)) }
    end
  end

  def amount(val)
    format_amount(val, denom: 'coda', html: false, hide_units: true)
  end
end
