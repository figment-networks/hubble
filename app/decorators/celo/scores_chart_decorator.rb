class Celo::ScoresChartDecorator < SimpleDelegator
  def point
    { t: time_bucket.to_date, y: factor_amount(total) }
  end

  private

  # Indexer returns score as `999996754839400000000000`
  SCORE_FACTOR = 22

  def factor_amount(amount)
    (amount.to_f * (10 ** -SCORE_FACTOR)).round(2)
  end
end
