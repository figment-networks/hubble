class Polkadot::AccountDetailsDecorator < SimpleDelegator
  def identity_fields
    %i[legal_name web_name riot_name email_name twitter_name].map do |field|
      value = clean_unicode_characters(send(field))
      value.present? ? { label: field.to_s.humanize, value: value } : nil
    end.compact
  end

  def balances
    %i[deposits bonded unbonded withdrawn].map do |field|
      value_sum = send(field)&.sum { |deposit| deposit['amount'].to_i } || 0
      { header: field.to_s.humanize, value: value_sum }
    end
  end

  private

  def clean_unicode_characters(string)
    string&.gsub(/[^[:print:]]/i, '')
  end
end
