class Livepeer::Adapters::OrchestratorAdapter < Livepeer::Adapters::BaseAdapter
  attribute :active
  attribute :reward_cut
  attribute :fee_share
  attribute :total_stake
  attribute :name
  attribute :description
  attribute :website_url

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
    sanitize(data.profile.name)
  end

  def description
    sanitize(data.profile.description)
  end

  def website_url
    sanitize(data.profile.website)
  end
end
