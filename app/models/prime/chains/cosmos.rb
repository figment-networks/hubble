class Prime::Chains::Cosmos < Prime::Chain
  def client
    @client ||= ::Cosmos::Client.new(api_url)
  end

  def figment_validators
    figment_validator_addresses.map do |address|
      Prime::Cosmos::ValidatorDecorator.new(::Cosmos::Chain.primary.validators.find_by(address: address))
    end
  end
end
