class Iris::SyncBase < Cosmoslike::SyncBase
  def get_stake_info
    path = 'stake/validators'
    r = lcd_get(path)
    r.is_a?(Array) ? r : nil
  end

  def get_validator_delegations(validator_operator_id)
    lcd_get(['stake/validators', validator_operator_id, 'delegations'])
  end

  def get_validator_unbonding_delegations(validator_operator_id)
    lcd_get(['stake/validators', validator_operator_id, 'unbonding-delegations'])
  end

  def get_transactions(params = nil)
    params ||= {}
    params[:search_request_size] = 1000
    lcd_get('txs', params)
  end

  def get_account_balances(account)
    r = lcd_get(['bank/accounts', account])
    if r.is_a?(Hash)
      return r['value']['coins']
    else
      return []
    end
  end

  def get_community_pool
    nil
  end

  def get_account_delegations(account)
    lcd_get(['stake/delegators', account, 'delegations'])
  end

  def get_account_unbonding_delegations(account)
    lcd_get(['stake/delegators', account, 'unbonding-delegations'])
  end

  def get_account_delegation_transactions(account)
    lcd_get(['stake/delegators', account, 'txs'])
  end

  def get_account_rewards(account, _validator = nil)
    r = lcd_get(['distribution', account, 'rewards'].compact)
    r['total']
  end

  def get_validator_rewards(_validator_operator_id)
    nil # unsupported
  end

  def get_governance
    {}
  end

  # Iris returns 404 on lcd_get('staking/pool') endpoint
  def get_staking_pool
    nil
  end
end
