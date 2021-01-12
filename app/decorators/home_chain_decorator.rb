class HomeChainDecorator < SimpleDelegator
  def orchestrator_count; end

  def validator_count; end

  def baker_count; end

  def avg_block_time; end

  def rewards_rate; end

  def daily_rewards; end

  def staking_participation; end

  def token_display
    self.class.parent::Chain::DEFAULT_TOKEN_DISPLAY
  end

  def token_price?(token_prices)
    token_price(token_prices).present?
  end

  def token_price(token_prices)
    token_prices[token_display]['USD'] unless token_prices.nil? || token_prices[token_display].nil?
  end
end
