class Common::ValidatorEvents::NConsecutive < Common::ValidatorEvent
  def icon_name
    'exclamation-circle'
  end

  def positive?
    false
  end

  def n
    data['n']
  end

  def twitter_msg
    "#{validatorlike.short_name} missed #{n} consecutive precommits on #{chainlike.network_name}/#{chainlike.ext_id} as of block #{height}"
  end

  def page_title
    "#{validatorlike.short_name} missed #{n} consecutive precommits as of block #{height}"
  end
end
