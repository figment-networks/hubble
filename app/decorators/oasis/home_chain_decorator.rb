class Oasis::HomeChainDecorator < HomeChainDecorator
  def validator_count
    @validator_count ||= client.validators.select(&:active?).count
  rescue StandardError # this is not perfect but this call can fail in different ways and we don't want homepage to fail
    nil
  end

  def avg_block_time
    @avg_block_time ||= client.block_times.avg
  rescue StandardError # this is not perfect but this call can fail in different ways and we don't want homepage to fail
    nil
  end
end
