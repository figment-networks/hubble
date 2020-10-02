class Iris::Transactions::MessageDecorator < Cosmoslike::Transactions::MessageDecorator
  private

  def humanized_type
    sanitized = @object['type'].sub(/^irishub\//, '')
    case sanitized
    when 'bank/Send' then 'Send'
    else sanitized
    end
  end
end
