module Prime
  class NetworkEvent < Common::Resource
    field :create_date, type: :timestamp
    field :update_date, type: :timestamp
    field :title
    field :assets
    field :details
    field :event_date
    field :soft_date
    field :status
    field :category
    field :importance
    field :source
    field :network, type: Prime::Network
    field :success, default: true

    alias success? success

    def initialize(attr, network)
      super(attr)
      @network = network
      if success
        @title = attr['eventName']
        @source = attr['resources'][0]['link']
        @create_date = Time.zone.parse(attr['createDate'])
        @update_date = Time.zone.parse(attr['updateDate']) if attr['updateDate']
        @event_date = Time.zone.parse(attr['eventDate']) if attr['eventDate']
        # softDate is not a date - ie. '2021 Q3'
        @soft_date = attr['softDate'] if attr['softDate']
      end
    end

    def self.failed(network)
      new({ 'success' => false }, network)
    end
  end
end
