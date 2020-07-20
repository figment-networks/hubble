class Cosmoslike::AccountDecorator
  attr_accessor :address

  def initialize( chain, address )
    @chain = chain
    @namespace = chain.class.name.deconstantize.constantize
    @address = address
  end

  def error?
    balances.nil?
  end

  def balances
    begin
      @_balances ||= @chain.syncer.get_account_balances( @address )
    rescue @chain.namespace::SyncBase::CriticalError
      return nil
    end

    return [ { denom: @chain.token_map[@chain.primary_token]['display'], amount: 0 } ] if @_balances.nil?
    @_balances.map do |balance|
      { denom: balance['denom'], amount: balance['amount'].to_f }
    end
  end

  def has_outstanding_rewards?( validator=nil )
    outstanding_rewards(validator).any?
  end

  def outstanding_rewards( validator=nil )
    begin
      @_rewards ||= @chain.syncer.get_account_rewards( @address, validator )
    rescue @chain.namespace::SyncBase::CriticalError
      return nil
    end

    return [] if @_rewards.nil?
    @_rewards.map do |reward|
      # Rails.logger.debug "REWARD AMOUNT: #{reward.inspect}"
      { amount: reward['amount'].to_f, denom: reward['denom'] }
    end
  end

  def delegation_transactions
    begin
      @_delegation_transactions ||= @chain.syncer.get_account_delegation_transactions( @address )
    rescue @chain.namespace::SyncBase::CriticalError
      return nil
    end

    return nil if @_delegation_transactions.nil?

    @_delegation_transactions
      .map { |dt| @chain.namespace::TransactionDecorator.new( @chain, dt ) }
      .reject(&:error?)
  end

  def delegations
    begin
      @_delegations ||= @chain.syncer.get_account_delegations( @address )
      @_unbonding ||= @chain.syncer.get_account_unbonding_delegations( @address )
    rescue @chain.namespace::SyncBase::CriticalError
      return nil
    end

    r = []

    (@_delegations||[]).each do |delegation|
      r << decorate_delegation( delegation )
    end

    (@_unbonding||[]).each do |unbonding|
      (unbonding['entries']||[unbonding]).each do |entry|
        r << decorate_unbonding( unbonding, entry )
      end
    end

    r
  end

  def total_delegations( filter: :all )
    filtered = case filter
    when :all
      delegations
    when :bonded
      delegations.select { |d| d[:status] == 'bonded' }
    when :unbonding
      delegations.select { |d| d[:status] == 'unbonding' }
    else
      raise ArgumentError.new("Invalid filter: #{filter.inspect}")
    end

    filtered.inject(0) { |acc, del| acc + del[:amount] }
  end

  protected

  def decorate_unbonding( unbonding, entry )
    {
      validator: find_validator(unbonding['validator_address']),
      raw_operator: unbonding['validator_address'],
      amount: entry['balance'].to_f * (10 ** -@chain.token_map[@chain.primary_token]['factor']),
      height: entry['creation_height'].to_i,
      ends_at: DateTime.parse(entry['completion_time']),
      status: 'unbonding'
    }
  end

  def decorate_delegation( delegation )
    validator = find_validator(delegation['validator_address'])
    tokens = delegation['shares'].to_f

    if validator
      begin
        tokens = (tokens / validator.info_field('delegator_shares').to_f) * validator.info_field('tokens').to_f
      rescue
        delegation['shares'].to_f
      end
    end

    {
      validator: validator,
      raw_operator: delegation['validator_address'],
      amount: tokens * (10 ** -@chain.token_map[@chain.primary_token]['factor']),
      status: 'bonded'
    }
  end

  private

  def find_validator( operator_address )
    @chain.validators.find_by( "info->>'operator_address' = ?", operator_address )
  end

end
