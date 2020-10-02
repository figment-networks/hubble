class Common::ValidatorEvents::NOfM < Common::ValidatorEvent
  def icon_name
    'exclamation-circle'
  end

  def positive?
    false
  end

  def n
    data['n']
  end

  def m
    data['m']
  end

  def twitter_msg
    "#{validatorlike.short_name} missed #{n} of #{m} precommits on #{chainlike.network_name}/#{chainlike.ext_id} as of block #{height}"
  end

  def page_title
    "#{validatorlike.short_name} missed #{n} of #{m} precommits as of block #{height}"
  end
end
