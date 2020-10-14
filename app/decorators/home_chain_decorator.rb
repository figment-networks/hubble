require 'cryptocompare'

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

  def token_price?
    token_price.present?
  end

  def token_price
    token_prices[token_display]['USD'] unless token_prices.nil? || token_prices[token_display].nil?
  end

  private

  def token_prices
    Rails.cache.fetch('token_prices', expires_in: 4.hours) do
      Cryptocompare::Price.find(%i[ATOM LPT KAVA DOT XTZ LUNA IRIS], :USD)
    end
  rescue StandardError
    nil
  end
end
