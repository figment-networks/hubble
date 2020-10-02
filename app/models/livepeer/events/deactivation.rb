class Livepeer::Events::Deactivation < Livepeer::Event
  def positive?
    false
  end

  def icon_name
    'unlink'
  end
end
