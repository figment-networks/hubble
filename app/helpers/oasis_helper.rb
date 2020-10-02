module OasisHelper
  def oasis_chain_voting_power_online_percentage(height)
    active = @validators.select(&:active?)
    total_voting_power = active.sum(&:recent_voting_power)

    online = @validators.select { |v| v.online?(height) }
    online_voting_power = online.sum(&:recent_voting_power)

    return 'Cannot calculate' if online_voting_power.zero? || total_voting_power.zero?

    ((online_voting_power.to_f / total_voting_power.to_f) * 100).round(0)
  end

  def voting_power_percent(validator_total_shares, total_voting_power)
    round_if_whole((validator_total_shares.to_f / total_voting_power.to_f) * 100, 2)
  end

  def delegation_share(validators_total_delegations, delegators_shares)
    delegators_shares.to_f / validators_total_delegations.sum(&:shares)
  end

  def to_partial_path(event)
    '/common/validator_events/' + event.kind
  end
end
