class Common::Event::NConsecutive < Common::Event
  def initialize(event, chain)
    super(event, chain)
    @icon_name = 'exclamation-circle'
    @data['n'] = event['data']['threshold']
  end

  def positive?
    false
  end
end
