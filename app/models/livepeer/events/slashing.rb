class Livepeer::Events::Slashing < Livepeer::Event
  store_accessor :data, :penalty

  def penalty
    super.to_d
  end

  def positive?
    false
  end

  def icon_name
    'slash'
  end
end
