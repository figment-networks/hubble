class Prime::Chains::Terra < Prime::Chain
  def client
    @client ||= ::Terra::Client.new(api_url)
  end

  def figment_validators
    figment_validator_addresses.map do |address|
      Prime::Terra::ValidatorDecorator.new(::Terra::Chain.primary.validators.find_by(address: address))
    end
  end
end
