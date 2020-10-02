class Polkadot::HomeChainDecorator < HomeChainDecorator
  def validator_count
    client.validators.select(&:online).count
  rescue StandardError
  end

  def avg_block_time; end
end
