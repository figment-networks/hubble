class Livepeer::Round < ApplicationRecord
  belongs_to :chain

  has_many :pools, dependent: :destroy
  has_many :shares, through: :pools
  has_many :stakes, dependent: :delete_all
  has_many :bonds, dependent: :delete_all
  has_many :unbonds, dependent: :delete_all
  has_many :rebonds, dependent: :delete_all
  has_many :events, dependent: :delete_all

  has_many :reward_cut_changes, class_name: 'Livepeer::Events::RewardCutChange'
  has_many :missed_reward_calls, class_name: 'Livepeer::Events::MissedRewardCall'
  has_many :deactivations, class_name: 'Livepeer::Events::Deactivation'
  has_many :slashings, class_name: 'Livepeer::Events::Slashing'

  def previous_round
    chain.rounds.order(number: :desc).where('number < ?', number).take
  end

  def next_round
    chain.rounds.order(number: :asc).where('number > ?', number).take
  end

  def to_param
    number.to_s
  end
end
