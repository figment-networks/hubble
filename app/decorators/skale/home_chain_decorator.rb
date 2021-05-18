class Skale::HomeChainDecorator < HomeChainDecorator
  def validator_count
    client.validators_count
  rescue StandardError
    nil
  end
end
