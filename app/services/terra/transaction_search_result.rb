module Terra
  class TransactionSearchResult < Common::Resource
    field :network
    field :chain_id
    field :chain
    field :hash
    field :type
    field :sender
    field :receiver
    field :memo
    field :time, type: :timestamp
    field :height

    def initialize(attrs = {})
      super(attrs)
      @type = attrs['events'][0]['kind']
      @chain = Terra::Chain.find_by(slug: attrs['chain_id'])
    end
  end
end
