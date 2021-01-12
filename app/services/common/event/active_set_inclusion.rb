class Common::Event::ActiveSetInclusion < Common::Event
  def initialize(event, chain)
    super(event, chain)
    @kind = self.class.name.split('::').last.underscore
    if (event['kind'] == 'joined_active_set') || (event['kind'] == 'joined_set')
      @data = { 'status' => 'added' }
      @icon_name = 'link'
    else
      @data = { 'status' => 'removed' }
      @icon_name = 'unlink'
    end
  end

  def positive?
    data['status'] == 'added'
  end
end
