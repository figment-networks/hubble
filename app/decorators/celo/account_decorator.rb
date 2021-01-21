class Celo::AccountDecorator < SimpleDelegator
  def balances
    %i[gold_balance total_locked_gold total_nonvoting_locked_gold stable_token_balance].map do |field|
      { header: field.to_s.humanize, value: send(field) || 0 }
    end
  end
end
