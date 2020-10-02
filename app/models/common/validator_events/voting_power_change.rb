class Common::ValidatorEvents::VotingPowerChange < Common::ValidatorEvent
  def icon_name
    'battery-half'
  end

  THRESHOLD = 0.5 / 100.0

  class << self
    def validator_removed_from_active_set_in_same_block?
      !block.validator_in_set?(validator)
    end

    def significant_change?(from, to)
      return true if (from || 0).zero?

      ((to - from).abs / from.to_f) >= THRESHOLD
    end
  end

  def positive?
    percentage_change(false) > 0
  end

  def from
    data.fetch('from', 0) || 0
  end

  def to
    data.fetch('to', 0) || 0
  end

  def delta
    to - from
  end

  def percentage_change(round = true)
    return 100 if from.zero?

    num = to - from
    denom = from.to_f
    change = (num / denom) * 100.0
    round ? change.round(1) : change
  end

  def twitter_msg
    "#{validatorlike.short_name} voting power on #{chainlike.network_name}/#{chainlike.ext_id} changed: #{from} -> #{to} (#{format('%+d', delta)} / #{format('%+.1f%%', percentage_change)}) at block #{height}"
  end

  def page_title
    "#{validatorlike.short_name} voting power changed: #{from} -> #{to} at block #{height}"
  end
end
