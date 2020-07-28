class Polkadot::IdentityDecorator < SimpleDelegator
  def identity_fields
    [:legal_name, :web_name, :riot_name, :email_name, :twitter_name].map do |field|
      value = clean_unicode_characters(send(field))
      value.present? ? {label: field.to_s.humanize, value: value } : nil
    end.compact
  end

  private

  def clean_unicode_characters(string)
    string&.gsub(/[^[:print:]]/i, '')
  end
end
