class Polkadot::ValidatorFetcher
  attr_reader :client

  def initialize(client)
    @client = client
  end

  def perform(height)
    validator_details = client.validator_details(height)
    era_sequence = validator_details['last_era_sequences'].first
    attributes = era_sequence.slice('total_stake', 'own_stake', 'commission', 'reward_points')
    attributes.merge!(validator_details.slice('stash_account', 'started_at'))
    attributes.merge!(account_details: account_details(attributes['stash_account']))
    Polkadot::Validator.new(attributes)
  end

  private

  def account_details(account)
    client.account_details(account)
  rescue Common::IndexerClient::Error
    Polkadot::AccountDetails.failed(account)
  end
end
