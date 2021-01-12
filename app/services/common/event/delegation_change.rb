class Common::Event::DelegationChange < Common::Event
  def initialize(event, chain)
    super(event, chain)
    @kind = self.class.name.split('::').last.underscore
    @delegators = event['data']['stash_accounts']

    if event['kind'] == 'delegation_joined'
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
