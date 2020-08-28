class Cosmoslike::HomeChainDecorator < HomeChainDecorator
  def validator_count
    validators.count unless validators.nil?
  end

  def avg_block_time
    average_block_time
  end

  def rewards_rate
    chain_instance.rewards_rate
  end

  def daily_rewards
    chain_instance.daily_rewards
  end

  def staking_participation
    chain_instance.staking_participation
  end

  private

  def chain_instance
    __getobj__
  end
end
