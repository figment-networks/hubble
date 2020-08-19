class Cosmoslike::ValidatorDelegationsDecorator
  include FormattingHelper

  def initialize( chain, validator )
    @chain = chain
    @namespace = chain.class.name.deconstantize.constantize
    @validator = validator
  end

  def error?
    delegations.nil?
  end

  def empty?
    delegations.empty?
  end

  def delegations
    @delegations ||= fetch_delegations
  end

  protected

  def fetch_delegations
    decorated_delegations = []
    decorated_delegations.concat validator_delegations.map { |delegation| decorate_delegation(delegation) }
    decorated_delegations.concat unbondings.map { |delegation| decorate_unbonding(delegation) }
    decorated_delegations
  rescue @chain.namespace::SyncBase::CriticalError
    return nil
  end

  def validator_delegations
    Rails.cache.fetch("#{@chain.slug}/#{@validator.id}/validator_delegations", expires_in: 1.day) do
      @chain.syncer(30000).get_validator_delegations(@validator.owner)
    end
  end

  def unbondings
    Rails.cache.fetch("#{@chain.slug}/#{@validator.id}/unbondings", expires_in: 1.day) do
      @chain.syncer.get_validator_unbonding_delegations(@validator.owner)
    end
  end

  def decorate_delegation( delegation )
    tokens = (delegation['shares'].to_f / @validator.info_field('delegator_shares').to_f) * @validator.info_field('tokens').to_f
    {
      account: delegation['delegator_address'],
      validator: @chain.accounts.select {|account| account.address == delegation['delegator_address']}.try(:validator),
      amount: tokens * (10 ** -@chain.token_map[@chain.primary_token]['factor']),
      share: (delegation['shares'].to_f / @validator.info_field('delegator_shares').to_f) * 100,
      status: 'bonded'
    }
  end

  def decorate_unbonding( unbonding )
    {
      account: unbonding['delegator_address'],
      validator: @chain.accounts.select {|account| account.address == unbonding['delegator_address']}.try(:validator),
      amount: unbonding['entries'].inject(0) { |acc, e| acc + e['balance'].to_f },
      status: 'unbonding'
    }
  end
end
