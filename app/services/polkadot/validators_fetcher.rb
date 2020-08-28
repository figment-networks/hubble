class Polkadot::ValidatorsFetcher
  attr_reader :client

  def initialize(client)
    @client = client
  end

  def perform(height)
    validators_hash = {}

    client.validators_uptime(height).each do |uptime|
      validators_hash[uptime['stash_account']] = uptime.slice('accumulated_uptime')
    end

    sessions(height).each do |session|
      validators_hash[session['stash_account']].merge!(session.slice('online'))
    end

    stakings(height).each do |staking|
      validators_hash[staking['stash_account']].merge!(staking.slice('total_stake', 'commission'))
    end

    validators_hash.map do |stash_account, validator|
      Polkadot::Validator.new(
        validator.merge(
          stash_account: stash_account,
          account_details: account_details(stash_account)
        )
      )
    end
  end

  private

  def sessions(height)
    validators_by_height(height)['session_items']
  end

  def stakings(height)
    validators_by_height(height)['era_items']
  end

  def validators_by_height(height)
    @validators_by_height ||= client.validators_by_height(height)
  end

  def account_details(account)
    client.account_details(account)
  rescue Common::IndexerClient::Error
    Polkadot::AccountDetails.failed(account)
  end
end
