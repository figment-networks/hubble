class Polkadot::AccountDecorator < SimpleDelegator
  attr_reader :chain

  def initialize(account, chain)
    @chain = chain
    super(account)
  end

  #TODO: these need to be revisited for Validators. Most probably we'll need two presenters - one for
  # a regular account, and one for a Validator.
  def balances
    [
      { header: 'Other stake', balance: free },
      { header: 'Own stake', balance: reserved }
    ]
  end

  #TODO: implement when we have mockup or indexer data for this endpoint
  def delegations
    []
  end

  #TODO: implement when we have mockup or indexer data for this endpoint
  def delegation_transactions
    []
  end

  #TODO: implement when we have mockup or indexer data for this endpoint
  def commission
    "1%"
  end
end
