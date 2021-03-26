class Mina::HomeChainDecorator < HomeChainDecorator
  def validator_count
    @validator_count ||= (validators.count rescue nil)
  end

  def avg_block_time
    block_times&.minutes_avg rescue nil
  end

  def staking_participation
    validators.sum(&:stake).to_f / current_block.total_currency * 100 rescue nil
  end

  def avg_block_time_units
    'MIN'
  end

  private

  def validators
    @validators ||= client.validators
  end

  def current_block
    @current_block ||= client.current_block
  end

  def block_times
    @block_times ||= client.block_times
  end
end
