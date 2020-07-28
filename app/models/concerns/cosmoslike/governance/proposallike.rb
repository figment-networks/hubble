module Cosmoslike::Governance::Proposallike
  extend ActiveSupport::Concern

  included do |klass|
    namespace = klass.name.split('::').first.constantize

    belongs_to :chain, class_name: "#{namespace}::Chain"
    has_many :deposits, class_name: "#{namespace}::Governance::Deposit", dependent: :delete_all
    has_many :votes, class_name: "#{namespace}::Governance::Vote", dependent: :delete_all

    scope :ordered_by_submit_time, -> { order( submit_time: :desc ) }
    scope :voting_open, -> { where( 'voting_end_time > ?', Time.now ) }
  end

  def to_param; ext_id.to_s; end

  def valid_proposal?
    !in_deposit_period? ||
    total_deposits_for_denom(chain.primary_token) >= chain.governance_params.min_deposit_amount
  end

  def total_deposits
    denoms.map do |denom|
      total_amount_for_denom = total_deposit
        .select { |d| d['denom'] == denom }
        .inject(0) { |acc, td| acc + td['amount'].to_i }
      { denom: denom, total_amount: total_amount_for_denom }
    end
  end

  def total_deposits_for_denom( denom )
    found = total_deposits.find { |dep| dep[:denom] == denom }
    return 0 if !found
    found[:total_amount]
  end

  # TODO: deposits is an array with denom, so... can
  #       more than one denom be included? what does that mean for tallys?
  def denoms
    total_deposit.map { |td| td['denom'] }.uniq
  end
  def denom
    denoms.first
  end

  def status_string
    case proposal_status.downcase
    when 'depositperiod' then 'Deposit Period'
    when 'votingperiod' then 'Voting Period'
    else proposal_status
    end
  end

  def ended?
    passed? || rejected? || voting_end_time.try(:past?)
  end

  def rejected?
    proposal_status.downcase == 'rejected'
  end

  def passed?
    proposal_status.downcase == 'passed'
  end

  def in_voting_period?
    proposal_status.downcase == 'votingperiod'
  end

  def in_deposit_period?
    proposal_status.downcase == 'depositperiod'
  end

  def cumulative_voting_power
    (tally_result_yes||0) + (tally_result_abstain||0) +
    (tally_result_no||0) + (tally_result_nowithveto||0)
  end

  def missing_vote_data?
    voting_end_time.try(:past?) && votes.count.zero? && cumulative_voting_power > 0
  end

  def missing_deposits_data?
    voting_end_time.try(:past?) && deposits.count.zero? && cumulative_voting_power > 0
  end
end
