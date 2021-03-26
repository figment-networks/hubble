class Prime::FailedNetworkDecorator < SimpleDelegator
  def price_usd
    0
  end

  def one_day_roi
    0
  end

  def one_month_roi
    0
  end

  def tohlcv_values
    []
  end
end
