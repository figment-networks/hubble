class Polkadot::AccountDetailsDecorator < SimpleDelegator
  def identity_fields
    %i[legal_name web_name riot_name email_name twitter_name].map do |field|
      value = clean_unicode_characters(send(field))
      value.present? ? { label: field.to_s.humanize, value: value } : nil
    end.compact
  end

  def balances
    %i[balance reserved misc_frozen fee_frozen deposits bonded unbonded withdrawn].map do |field|
      value_sum = send(field).respond_to?(:sum) ? send(field).sum { |deposit| deposit['amount'].to_i } : send(field)
      { header: field.to_s.humanize, value: value_sum || 0 }
    end
  end

  private

  def clean_unicode_characters(string)
    string&.gsub(/[^[:print:]]/i, '')
  end
end
