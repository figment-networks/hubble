class Polkadot::ValidatorsFetcher
  attr_reader :client

  def initialize(client)
    @client = client
  end

  def perform(height, sessions_height)
    validators_hash = {}

    stakings(height).each { |staking| validators_hash[staking['stash_account']] = staking }
    sessions(sessions_height).each do |session|
      validators_hash[session['stash_account']] ||= {}
      validators_hash[session['stash_account']].merge!(session)
    end
    client.validators_uptime(height).each do |uptime|
      validators_hash[uptime['stash_account']] ||= {}
      validators_hash[uptime['stash_account']].merge!(uptime)
    end
    validators = validators_hash.map { |_stash_account, validator| Polkadot::Validator.new(validator) }
    validators.sort_by { |v| [v.uptime, v.total_stake] }.reverse
  end

  private

  def sessions(height)
    validators_by_height(height)['session_items'] || []
  end

  def stakings(height)
    validators_by_height(height)['era_items'] || []
  end

  def validators_by_height(height)
    @validators_by_height ||= {}
    @validators_by_height[height] ||= client.validators_by_height(height)
  end
end
