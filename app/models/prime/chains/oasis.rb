class Prime::Chains::Oasis < Prime::Chain
  def client
    @client ||= ::Oasis::Client.new(api_url)
  end

  def figment_validators
    figment_validator_addresses.map do |address|
      Prime::Oasis::ValidatorDecorator.new(client.validator(address, 0, network: network, retrieve_delegations: false))
    end
  end
end
