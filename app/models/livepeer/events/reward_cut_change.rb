class Livepeer::Events::RewardCutChange < Livepeer::Event
  store_accessor :data, :reward_cut

  def positive?
    true
  end

  def icon_name
    'percent'
  end

  def page_title
    "#{transcoder.name_or_address} reward cut changed to #{reward_cut}% in round #{round.number}"
  end
end
