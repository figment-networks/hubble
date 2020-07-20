class Livepeer::Adapters::TranscoderAdapter < Livepeer::Adapters::BaseAdapter
  attribute :active
  attribute :reward_cut
  attribute :fee_share
  attribute :total_stake
  attribute :name
  attribute :description

  def reward_cut
    convert_percentage(data.reward_cut)
  end

  def fee_share
    convert_percentage(data.fee_share)
  end

  def total_stake
    convert_lpt_amount(data.total_stake)
  end

  def name
    data.profile.name&.strip&.presence
  end

  def description
    data.profile.description&.strip&.presence
  end
end
