class Prime::AccountDecorator < SimpleDelegator
  include ActionView::Helpers::NumberHelper

  def factor
    network.primary.reward_token_factor
  end

  def formatted_balance
    number_with_delimiter(balance.round(2))
  end

  def usd_balance
    number_to_currency(balance * network.token_metrics!.price_usd)
  end
end
