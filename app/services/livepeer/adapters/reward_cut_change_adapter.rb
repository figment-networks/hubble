class Livepeer::Adapters::RewardCutChangeAdapter < Livepeer::Adapters::EventAdapter
  attribute :reward_cut

  def reward_cut
    convert_percentage(data.reward_cut)
  end
end
