class Cosmoslike::TransactionDecorator
  include FormattingHelper

  def initialize(chain, transaction_hash_or_data)
    # TODO: cache!
    @chain = chain
    @namespace = chain.namespace
    @object = transaction_hash_or_data.is_a?(Hash) ? transaction_hash_or_data : chain.syncer.get_transaction(transaction_hash_or_data)
    raise "Could not retrieve transaction: #{transaction_hash}" if @object.nil?
  end

  def to_param
    hash
  end

  def height
    @object['height']
  end

  def hash
    @object['txhash']
  end

  def dump
    @object.as_json
  end

  def amount_raw(denom: nil, from: nil, to: nil)
    if !@object['logs'][0]['success']
      return 0
    end

    msgs = @object['tx']['value']['msg'].select { |msg| msg['type'] == get_amount_msg_type }

    if from
      msgs = msgs.select { |msg| msg['value']['from_address'] == from }
    end

    if to
      msgs = msgs.select { |msg| msg['value']['to_address'] == to }
    end

    msgs.inject(0) do |acc, msg|
      amount = msg['value']['amount'].is_a?(Array) ?
        msg['value']['amount'] :
        [msg['value']['amount']]

      acc + amount.inject(0) do |acc2, amount2|
        next acc2 if amount2['denom'] != denom

        acc2 + amount2['amount'].to_f
      end
    end
  end

  def fees_raw(denom: nil)
    denom ||= @chain.primary_token
    @object['tx']['value']['fee']['amount'].inject(0) do |acc, fee|
      next acc if fee['denom'] != denom

      acc + fee['amount'].to_f
    end
  rescue StandardError
    0
  end

  def gas_raw
    @object['tx']['value']['fee']['gas'].to_i
  end

  def fees
    @object['tx']['value']['fee']['amount'].map do |fee|
      next if fee['denom'].blank?

      format_amount(fee['amount'].to_i, @chain, denom: fee['denom'])
    end.compact
  rescue StandardError
    []
  end

  def gas
    format_amount(gas_raw, @chain, denom: 'gas')
  end

  def error?
    return true if @object.has_key?('error')

    code = @object['code']

    !code.nil? && code != 0
  end

  def error_message
    return @object['error'] if @object.has_key?('error')

    code = @object['code']

    case code
    when 1 then 'Internal Error'
    when 2 then 'Transaction Parse Error'
    when 3 then 'Invalid Sequence'
    when 4 then 'Unauthorized'
    when 5 then 'Insufficient Funds'
    when 6 then 'Unknown Request'
    when 7 then 'Invalid Address'
    when 8 then 'Invalid Public Key'
    when 9 then 'Unknown Address'
    when 10 then 'Insufficient Coins'
    when 11 then 'Invalid Coins'
    when 12 then 'Out of Gas'
    when 13 then 'Memo Too Large'
    when 14 then 'Insufficient Fee'
    when 15 then 'Too Many Signatures'

    when 103 then 'Validator Not Jailed'

    else 'Unknown Error'
    end
  end

  def type
    @object['tx']['type']
  end

  def tags
    tags = @object['tags']
    (tags || []).map { |tag| @namespace::Transactions::TagDecorator.new(tag, @chain) }
  end

  def messages
    (@object['tx']['value']['msg'] || []).map { |msg| @namespace::Transactions::MessageDecorator.new(msg, @chain) }
  end

  def gas_wanted
    wanted = @object['gas_wanted']

    if !wanted.nil?
      format_amount(wanted.to_i, @chain, denom: 'gas')
    else
      '&mdash;'.html_safe
    end
  end

  def gas_used
    used = @object['gas_used']

    format_amount(used.to_i, @chain, denom: 'gas')
  end

  def log
    @object['log']
  end

  def memo
    @object['tx']['value']['memo']
  end

  def signatures
    @object['tx']['value']['signatures']
  end

  private

  def get_amount_msg_type
    'cosmos-sdk/MsgSend'
  end
end
