class Common::Event::VotingPowerChange < Common::Event
  def initialize(event, chain)
    super(event, chain)
    @kind = self.class.name.split('::').last.underscore
    @icon_name = 'battery-half'
    @from = event['data']['before'].to_f / chain.primary_token_divisor
    @to = event['data']['after'].to_f / chain.primary_token_divisor
  end

  def positive?
    to > from
  end
end
