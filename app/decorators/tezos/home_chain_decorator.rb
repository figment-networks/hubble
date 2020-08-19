require_relative '../../../lib/indexer/resources/baker'

class Tezos::HomeChainDecorator < HomeChainDecorator

  #TODO: rescue more specific error
  def baker_count
    @baker_count ||= Indexer::Baker.count
  rescue # this is not perfect but this call can fail in different ways and we don't want homepage to fail
    nil
  end
end
