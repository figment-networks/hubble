class Common::Event::NOfM < Common::Event
  def initialize(event, chain)
    super(event, chain)
    @icon_name = 'exclamation-circle'
    @data['n'] = event['data']['threshold']
    @data['m'] = event['data']['max_validator_sequences']
  end

  def positive?
    false
  end
end
