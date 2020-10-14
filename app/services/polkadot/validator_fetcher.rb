class Polkadot::ValidatorFetcher
  attr_reader :client

  def initialize(client)
    @client = client
  end

  def perform(stash_account)
    validator_details = client.validator_details(stash_account)
    era_sequence = validator_details['last_era_sequences']&.first
    attributes = {}
    attributes.merge!(era_sequence) if era_sequence
    attributes.merge!(validator_details)
    attributes.merge!('account_details' => account_details(attributes['stash_account']))
    Polkadot::Validator.new(attributes)
  end

  private

  def account_details(account)
    client.account_details(account)
  rescue Common::IndexerClient::Error
    Polkadot::AccountDetails.failed(account)
  end
end
