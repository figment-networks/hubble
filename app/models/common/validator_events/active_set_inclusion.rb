class Common::ValidatorEvents::ActiveSetInclusion < Common::ValidatorEvent
  def icon_name
    positive? ? 'link' : 'unlink'
  end

  def positive?
    added?
  end

  def added?
    data['status'] == 'added'
  end

  def removed?
    !added?
  end

  def twitter_msg
    "#{validatorlike.short_name} #{added? ? 'added to' : 'removed from'} active set on #{chainlike.network_name}/#{chainlike.ext_id} at block #{height}"
  end

  def page_title
    "#{validatorlike.short_name} #{added? ? 'added to' : 'removed from'} active set at block #{height}"
  end
end
