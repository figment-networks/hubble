class Polkadot::AccountDecorator < SimpleDelegator
  attr_reader :chain

  def initialize(account, chain)
    @chain = chain
    super(account)
  end

  #TODO: implement when we have mockup or indexer data for this endpoint
  def delegations
    []
  end

  #TODO: implement when we have mockup or indexer data for this endpoint
  def delegation_transactions
    []
  end
end
