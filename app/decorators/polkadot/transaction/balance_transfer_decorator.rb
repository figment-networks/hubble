class Polkadot::Transaction::BalanceTransferDecorator < Polkadot::Transaction::DefaultDecorator
  def humanized_method
    'Send'
  end

  def humanized_attributes
    [
      { name: 'From', value: from, type: :account },
      { name: 'To', value: account, type: :account },
      { name: 'Amount', value: amount, type: :amount },
      { name: 'Signature', value: signature }
    ]
  end

  def from
    arguments_array[0]
  end

  def amount
    arguments_array[1]
  end

  def parameters
  end

  def self.can_decorate?(transaction)
    transaction.section == 'balances' && transaction.method_name == 'transfer'
  end

  private

  def arguments_array
    args.split(',')
  end
end
