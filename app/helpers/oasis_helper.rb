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
    "/common/redesign/validator_events/#{event.kind_class}"
  end

  def oasis_format_amount(amount, chain = nil, denom: nil, thousands_delimiter: true, hide_units: false, html: true, precision: 3)
    chain ||= @chain
    denom ||= chain.token_display
    token = chain.token_map.select { |_k, v| v['display'] == denom }

    if denom == 'GAS'
      factor = 0.0
    else
      factor = token.values.first['factor'].to_f
    end

    amount /= (10 ** factor)

    number_string = thousands_delimiter ? number_with_delimiter(round_if_whole(amount, precision)) : round_if_whole(amount, precision)
    denom_string = hide_units ? '' : " #{denom}"

    if html
      number_string = "<span class='text-monospace'>#{number_string}</span>"
      denom_string = "<span class='text-sm text-muted sup'>#{denom_string}</span>" if denom_string.present?
    end

    "#{number_string}#{denom_string}".strip.html_safe
  end
end
