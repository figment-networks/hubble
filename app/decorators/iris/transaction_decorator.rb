class Iris::TransactionDecorator < Cosmoslike::TransactionDecorator
  def hash
    @object['hash']
  end

  def amount_raw( denom: nil, from: nil, to: nil )
    if @object['result']['Code'] != 0
      return 0
    end

    msgs = @object['tx']['value']['msg'].select { |msg| msg['type'] == get_amount_msg_type }

    if from
      msgs = msgs
        .select { |msg| msg['value']['inputs'].find { |i| i['address'] == from } }
        .map { |msg| msg['inputs'] }
    end

    if to
      msgs = msgs
        .select { |msg| msg['value']['outputs'].find { |o| o['address'] == to } }
        .map { |msg| msg['outputs'] }
    end

    msgs.inject(0) do |acc, msg|
      acc + msg['coins'].inject(0) do |acc2, amount2|
        next acc2 if amount2['denom'] != denom
        acc2 + amount2['amount'].to_f
      end
    end
  end

  def tags
    tags = @object['result']['Tags']
    (tags||[]).map { |tag| @namespace::Transactions::TagDecorator.new( tag, @chain ) }
  end

  def gas_wanted
    wanted = @object['result']['GasWanted']

    if !wanted.nil?
      format_amount( wanted.to_i, @chain, denom: 'gas' )
    else
      '&mdash;'.html_safe
    end
  end

  def gas_used
    used = @object['result']['GasUsed']

    format_amount( used.to_i, @chain, denom: 'gas' )
  end

  private

  def get_amount_msg_type
    'irishub/bank/Send'
  end
end
