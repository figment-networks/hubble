class Terra::TransactionDecorator < Cosmoslike::TransactionDecorator
  private

  def get_amount_msg_type
    if @chain.sdk_gte?('0.37.0')
      'bank/MsgSend'
    else
      'pay/MsgSend'
    end
  end
end
