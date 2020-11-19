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
    attributes.merge!('account_details' => account_details(attributes['stash_account'], attributes['display_name']))
    Polkadot::Validator.new(attributes)
  end

  private

  # TODO: enable fetching account details when that endpoint response time gets fixed
  def account_details(account, display_name)
    # client.account_details(account)
    # rescue Common::IndexerClient::Error
    Polkadot::AccountDetails.failed(account, display_name)
  end
end
