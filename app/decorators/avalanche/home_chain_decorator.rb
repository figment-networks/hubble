class Avalanche::HomeChainDecorator < HomeChainDecorator
  def validator_count
    client.validators_count
  rescue StandardError
  end
end
