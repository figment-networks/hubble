class Tezos::VotingPeriodTallyDecorator
  include FormattingHelper

  def initialize(period, votes)
    @period = period
    @votes = votes
  end

  %i{ yay nay pass }.each do |opt|
    define_method :"progress_#{opt}" do
      return 0 if no_votes?
      progress = send(:"raw_#{opt}").to_f / total_rolls.to_f
      round_if_whole(progress * 100, 2)
    end

    define_method :"raw_#{opt}" do
      return 0 if no_votes?
      filtered_votes = @votes.select { |v| v.vote.to_s == opt.to_s }
      filtered_votes.sum { |v| v.rolls }
    end

    define_method :"#{opt}_voters" do
      return 0 if no_votes?
      filtered_votes = @votes.select { |v| v.vote.to_s == opt.to_s }
      filtered_votes.count
    end

    define_method :"percent_#{opt}" do
      return 0 if no_votes?
      round_if_whole((send(:"raw_#{opt}").to_f / cumulative_voting_power.to_f) * 100, 2)
    end
  end


  def percent_didntvote
    round_if_whole(((total_rolls.to_f - cumulative_voting_power.to_f) / total_rolls) * 100, 2)
  end
  def percent_voted( precision=2 )
    round_if_whole((cumulative_voting_power.to_f / total_rolls.to_f) * 100, precision)
  end

  def cumulative_voting_power
    raw_yay + raw_nay + raw_pass
  end

  def non_abstain_voting_power
    raw_yay + raw_nay
  end

  def non_abstain_voting_percent
    raw_yay.to_f / non_abstain_voting_power.to_f
  end

  def total_rolls
    @period.total_rolls
  end

  def quorum_target
    @period.quorum
  end

  def quorum_percentage
    non_abstain_voting_power / total_rolls.to_f
  end

  def quorum_reached?
    non_abstain_voting_power >= quorum_target
  end

  def supermajority_reached?
    raw_yay.to_f / (raw_yay.to_f + raw_nay.to_f) >= 0.8
  end

  def no_votes?
    @votes.empty?
  end
end
