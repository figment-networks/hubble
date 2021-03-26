class Prime::Oasis::ValidatorDecorator < Prime::ValidatorDecorator
  def network_name
    'Oasis'
  end

  def uptime_as_percentage
    uptime * 100
  end

  def validator_events!
    @validator_events ||= network.primary.client.validator_events(network.primary, address, nil).map do |event|
      Prime::ValidatorEventDecorator.new(event)
    end
  end
end
