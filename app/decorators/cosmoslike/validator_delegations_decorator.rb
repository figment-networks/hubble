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
    begin
      @_delegations ||= @chain.syncer.get_validator_delegations( @validator.owner )
      @_unbonding ||= @chain.syncer.get_validator_unbonding_delegations( @validator.owner )
    rescue @chain.namespace::SyncBase::CriticalError
      return nil
    end

    r = []
    @_delegations ||= []
    @_unbonding ||= []

    @_delegations.each do |delegation|
      r << decorate_delegation( delegation )
    end

    @_unbonding.each do |unbonding|
      # Rails.logger.debug "\n\nUNBONDING ENTRIES: #{unbonding['delegator_address']}\n#{unbonding['entries']}\n\n"
      r << decorate_unbonding( unbonding )
    end

    r
  end

  protected

  def decorate_delegation( delegation )
    tokens = (delegation['shares'].to_f / @validator.info_field('delegator_shares').to_f) * @validator.info_field('tokens').to_f
    {
      account: delegation['delegator_address'],
      validator: @chain.accounts.find_by( address: delegation['delegator_address'] ).try(:validator),
      amount: tokens * (10 ** -@chain.token_map[@chain.primary_token]['factor']),
      share: (delegation['shares'].to_f / @validator.info_field('delegator_shares').to_f) * 100,
      status: 'bonded'
    }
  end

  def decorate_unbonding( unbonding )
    {
      account: unbonding['delegator_address'],
      validator: @chain.accounts.find_by( address: unbonding['delegator_address'] ).try(:validator),
      amount: unbonding['entries'].inject(0) { |acc, e| acc + e['balance'].to_f },
      status: 'unbonding'
    }
  end
end
