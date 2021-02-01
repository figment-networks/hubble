class Avalanche::SummaryChartDecorator < SimpleDelegator
  def point(chain)
    { t: time.to_date, y: factor_amount(total_delegated, chain) }
  end

  private

  def factor_amount(amount, chain)
    amount.to_f * (10 ** -(chain.token_map[chain.class::DEFAULT_TOKEN_REMOTE]['factor']))
  end
end
