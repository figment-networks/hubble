class Livepeer::HomeChainDecorator < HomeChainDecorator
  def orchestrator_count
    orchestrators&.count
  end
end
