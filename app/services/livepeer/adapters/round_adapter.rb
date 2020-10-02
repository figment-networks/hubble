class Livepeer::Adapters::RoundAdapter < Livepeer::Adapters::BaseAdapter
  attribute :initialized_at
  attribute :mintable_tokens

  has_many :pools
  has_many :stakes
  has_many :bonds
  has_many :unbonds
  has_many :rebonds

  has_many :reward_cut_changes, Livepeer::Events::RewardCutChange
  has_many :missed_reward_calls, Livepeer::Events::MissedRewardCall
  has_many :deactivations, Livepeer::Events::Deactivation
  has_many :slashings, Livepeer::Events::Slashing

  def initialized_at
    convert_timestamp(data.timestamp)
  end

  def mintable_tokens
    convert_lpt_amount(data.mintable_tokens)
  end
end
