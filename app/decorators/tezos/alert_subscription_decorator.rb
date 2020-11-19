require 'indexer/resources/baker'

class Tezos::AlertSubscriptionDecorator
  def initialize(sub)
    raise 'Tezos subscription required' unless sub.network == 'Tezos'

    @sub = sub
  end

  def baker_id
    @baker_id ||= @sub.alertable.address
  end

  def baker
    @baker ||= Indexer::Baker.retrieve(baker_id)
  end
end
