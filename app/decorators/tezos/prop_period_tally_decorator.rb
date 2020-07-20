class Tezos::PropPeriodTallyDecorator
  include FormattingHelper

  def initialize(period, votes)
    @period = period
    @votes = votes
  end

  def props
    props = []
    unique_props = @votes.uniq { |v| v.proposal_id }
    unique_props.each do |p|
      rolls = @votes.sum { |v| v.proposal_id == p.proposal_id ? v.rolls : 0 }
      props << [p.prop_name, p.proposal_id, rolls]
    end
    return props
  end

  def cumulative_voting_power
    @votes.sum { |v| v.rolls }
  end

  def total_rolls
    @period.total_rolls
  end

  def percent_voted( precision=2 )
    round_if_whole((@votes.count.to_f / @period.total_voters.to_f) * 100, precision)
  end
end
