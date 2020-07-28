class Iris::ValidatorDelegationsDecorator < Cosmoslike::ValidatorDelegationsDecorator
  protected

  def decorate_delegation( delegation )
    {
      account: delegation['delegator_addr'],
      validator: @chain.accounts.find_by( address: delegation['delegator_addr'] ).try(:validator),
      amount: delegation['shares'].to_f,
      share: (delegation['shares'].to_f / @validator.info_field('delegator_shares').to_f) * 100,
      status: 'bonded'
    }
  end

  def decorate_unbonding( unbonding )
    {
      account: unbonding['delegator_addr'],
      validator: @chain.accounts.find_by( address: unbonding['delegator_addr'] ).try(:validator),
      amount: unbonding['balance'].to_f * (10 ** @chain.token_map[@chain.primary_token]['factor']),
      status: 'unbonding'
    }
  end
end
