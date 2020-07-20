module Livepeer::FactoryHelpers
  def create_round(chain, number:, initialized_at:)
    create(
      :livepeer_round,
      chain: chain,
      number: number,
      initialized_at: initialized_at
    )
  end

  def create_share(pool, delegator_address, fees:, reward_tokens:)
    create(
      :livepeer_share,
      pool: pool,
      delegator_address: delegator_address,
      fees: fees,
      reward_tokens: reward_tokens
    )
  end


  def create_stake(round, delegator_address, pending_stake:, unclaimed_stake:)
    create(
      :livepeer_stake,
      round: round,
      delegator_address: delegator_address,
      pending_stake: pending_stake,
      unclaimed_stake: unclaimed_stake
    )
  end

  def create_transcoder(chain, address:)
    create(:livepeer_transcoder, chain: chain, address: address)
  end

  def create_unbond(round, withdraw_round, delegator_address, amount:)
    create(
      :livepeer_unbond,
      round: round,
      withdraw_round_number: withdraw_round.number,
      delegator_address: delegator_address,
      amount: amount
    )
  end

  def create_rebond(unbond, round = nil)
    create(
      :livepeer_rebond,
      round: (round || unbond.round),
      delegator_address: unbond.delegator_address,
      amount: unbond.amount,
      unbonding_lock_id: unbond.unbonding_lock_id
    )
  end

  def create_delegator_list(chain, addresses)
    create(:livepeer_delegator_list, chain: chain, addresses: addresses)
  end
end
