class Iris::AccountDecorator < Cosmoslike::AccountDecorator
  protected

  def decorate_unbonding( unbonding, entry )
    {
      validator: find_validator(unbonding['validator_addr']),
      raw_operator: unbonding['validator_addr'],
      amount: entry['balance'].to_f,
      height: entry['creation_height'].to_i,
      ends_at: DateTime.parse(entry['min_time']),
      status: 'unbonding'
    }
  end

  def decorate_delegation( delegation )
    {
      validator: find_validator(delegation['validator_addr']),
      raw_operator: delegation['validator_addr'],
      amount: delegation['shares'].to_f,
      status: 'bonded'
    }
  end
end
