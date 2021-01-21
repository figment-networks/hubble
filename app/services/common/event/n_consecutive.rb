class Common::Event::NConsecutive < Common::Event
  def initialize(event, chain)
    super(event, chain)
    @kind = self.class.name.split('::').last.underscore
    @icon_name = 'exclamation-circle'
    @data['n'] = event['data']['threshold']
  end

  def positive?
    false
  end
end
