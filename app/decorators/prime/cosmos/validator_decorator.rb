class Prime::Cosmos::ValidatorDecorator < Prime::ValidatorDecorator
  def network_name
    'Cosmos'
  end

  def uptime_as_percentage
    current_uptime * 100
  end

  def validator_events!
    []
  end

  def factored_commission
    info['commission']['commission_rates']['rate'].to_f * 100
  end
end
