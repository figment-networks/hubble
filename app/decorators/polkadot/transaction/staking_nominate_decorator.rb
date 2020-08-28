class Polkadot::Transaction::StakingNominateDecorator < Polkadot::Transaction::DefaultDecorator
  def humanized_method
    'Nominate'
  end

  def humanized_attributes
    targets.map { |target| { value: target, type: :account, class: 'border-bottom' } }.concat(
      super([:account, :signature])
    )
  end

  def parameters
  end

  def self.can_decorate?(transaction)
    transaction.section == 'staking' && transaction.method_name == 'nominate'
  end

  private

  def targets
    args.remove('[').remove(']').remove(' ').split(',')
  end
end
