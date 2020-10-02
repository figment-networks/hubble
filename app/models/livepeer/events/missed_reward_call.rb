class Livepeer::Events::MissedRewardCall < Livepeer::Event
  def positive?
    false
  end

  def icon_name
    'exclamation-circle'
  end
end
