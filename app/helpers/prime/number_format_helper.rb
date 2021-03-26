module Prime::NumberFormatHelper
  def price_change_color(change)
    change >= 0 ? 'success' : 'danger'
  end
end
