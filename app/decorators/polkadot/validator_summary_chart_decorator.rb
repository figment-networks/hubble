class Polkadot::ValidatorSummaryChartDecorator < SimpleDelegator
  def point(chain)
    { t: time_bucket.to_date, y: factor_amount(total_stake, chain).round(2) }
  end

  private

  #TODO: similar calculation is all around, probably we should refactor it
  def factor_amount(amount, chain)
    amount.to_f * (10 ** -(chain.token_map[chain.class::DEFAULT_TOKEN_REMOTE]['factor']))
  end
end
