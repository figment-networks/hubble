class Mina::TransactionsStatsDecorator < SimpleDelegator
  include FormattingHelper

  def initialize(chain, stats)
    @chain = chain
    @stats = stats.reverse
  end

  def payments_chart_data
    serialize(:payments_amount)
  end

  def fees_chart_data
    serialize(:fee_transfers_amount)
  end

  def work_fees_chart_data
    serialize(:jobs_amount)
  end

  private

  def serialize(key)
    @stats.map do |s|
      { t: s.time.iso8601, y: amount(s.send(key)) }
    end
  end

  def amount(val)
    format_amount(val, denom: 'mina', html: false, hide_units: true, thousands_delimiter: false)
  end
end
