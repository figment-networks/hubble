class Prime::Chains::Polkadot < Prime::Chain
  def client
    @client ||= ::Polkadot::Client.new(api_url)
  end

  def figment_validators
    figment_validator_addresses.map do |address|
      Prime::Polkadot::ValidatorDecorator.new(client.validator(address, network: network))
    end
  end
end
