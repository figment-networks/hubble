class Cosmoslike::HomeChainDecorator < HomeChainDecorator
  delegate :rewards_rate, to: :chain_instance
  delegate :daily_rewards, to: :chain_instance
  delegate :staking_participation, to: :chain_instance

  def validator_count
    validators&.select(&:active?)&.count
  end

  def avg_block_time
    average_block_time
  end

  private

  def chain_instance
    __getobj__
  end
end
