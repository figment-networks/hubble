class Livepeer::Events::RewardCutChange < Livepeer::Event
  store_accessor :data, :reward_cut

  def reward_cut
    super.to_d
  end

  def positive?
    true
  end

  def icon_name
    'percent'
  end
end
