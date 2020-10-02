class Polkadot::AccountDetailsDecorator < SimpleDelegator
  def identity_fields
    %i[legal_name web_name riot_name email_name twitter_name].map do |field|
      value = clean_unicode_characters(send(field))
      value.present? ? { label: field.to_s.humanize, value: value } : nil
    end.compact
  end

  # TODO: these need to be revisited for Validators. Most probably we'll need two presenters - one for
  # a regular account, and one for a Validator.
  def balances
    %i[deposits bonded unbonded withdrawn].map do |field|
      { header: field.to_s.humanize, values: send(field) }
    end
  end

  private

  def clean_unicode_characters(string)
    string&.gsub(/[^[:print:]]/i, '')
  end
end
