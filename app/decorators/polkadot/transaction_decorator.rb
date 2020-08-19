class Polkadot::TransactionDecorator
  TRANSACTION_DECORATORS = [
    Polkadot::Transaction::BalanceTransferDecorator,
    Polkadot::Transaction::StakingNominateDecorator,
    Polkadot::Transaction::StakingPayoutDecorator,
    Polkadot::Transaction::DefaultDecorator
  ]

  def self.decorate(transaction)
    TRANSACTION_DECORATORS.each do |decorator|
      return decorator.new(transaction) if decorator.can_decorate?(transaction)
    end
  end
end
