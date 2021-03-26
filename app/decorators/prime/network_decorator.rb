class Prime::NetworkDecorator < SimpleDelegator
  delegate :price_usd, to: :token_metrics!
  delegate :tohlcv_values, to: :token_price_time_series!

  def one_day_roi
    token_metrics!.one_day_price_change_percent_usd
  end

  def one_month_roi
    token_metrics!.one_month_price_change_percent_usd
  end
end
