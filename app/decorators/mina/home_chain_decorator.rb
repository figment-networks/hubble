class Mina::HomeChainDecorator < HomeChainDecorator
  def validator_count
    @validator_count ||= (client.validators.count rescue nil)
  end

  def avg_block_time
    @avg_block_time ||= (client.block_times.avg rescue nil)
  end
end
