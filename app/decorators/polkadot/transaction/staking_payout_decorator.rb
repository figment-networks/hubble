class Polkadot::Transaction::StakingPayoutDecorator < Polkadot::Transaction::DefaultDecorator
  def humanized_method
    'Payout stakers'
  end

  def humanized_attributes
    [
      { name: 'Stash account', value: stash_account, type: :account },
      { name: 'Era', value: era }
    ].concat(super([:account, :signature]))
  end

  def parameters
  end

  def stash_account
    arguments_array[0]
  end

  def era
    arguments_array[1]
  end

  def self.can_decorate?(transaction)
    transaction.section == 'staking' && transaction.method_name == 'payoutStakers'
  end

  private

  def arguments_array
    args.split(',')
  end
end
