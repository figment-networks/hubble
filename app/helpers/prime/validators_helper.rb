module Prime::ValidatorsHelper
  VALIDATOR_EVENTS_LIMIT = 50

  def prime_network_average_uptime(network)
    uptime = network.figment_validators!.sum(&:uptime_as_percentage) / network.figment_validators!.count
    number_to_percentage(uptime, precision: 2)
  end

  def build_validator_events
    validator_events = []
    user_networks.each do |network|
      network.figment_validators!.each do |validator|
        validator_events += validator.validator_events!
      end
    end
    validator_events.sort_by!(&:time).reverse![0, [validator_events.length, VALIDATOR_EVENTS_LIMIT].min]
  end
end
