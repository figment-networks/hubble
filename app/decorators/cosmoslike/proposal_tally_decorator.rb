class Cosmoslike::ProposalTallyDecorator
  include FormattingHelper

  def initialize(proposal)
    @proposal = proposal
  end

  %i[yes no abstain nowithveto].each do |opt|
    define_method :"progress_#{opt}" do
      return 0 if no_votes?

      progress = send(:"raw_#{opt}") / total_bonded
      round_if_whole(progress * 100, 2)
    end

    define_method :"raw_#{opt}" do
      @proposal.send(:"tally_result_#{opt}")
    end

    define_method :"percent_#{opt}" do
      return 0 if no_votes?

      round_if_whole((send(:"raw_#{opt}") / cumulative_voting_power) * 100, 2)
    end
  end

  def percent_didntvote
    round_if_whole(((total_bonded - cumulative_voting_power) / total_bonded) * 100, 2)
  end

  def percent_voted(precision = 2)
    round_if_whole((cumulative_voting_power / total_bonded) * 100, precision)
  end

  def cumulative_voting_power
    [raw_yes, raw_no, raw_abstain, raw_nowithveto].map { |t| t || 0 }.sum
  end

  def non_abstain_voting_power
    [raw_yes, raw_no, raw_nowithveto].map { |t| t || 0 }.sum
  end

  def total_bonded
    @proposal.chain.staking_pool['bonded_tokens'].to_f
  end

  def quorum_target
    total_bonded * @proposal.chain.governance_params.quorum
  end

  def quorum_percentage
    non_abstain_voting_power / total_bonded.to_f
  end

  def quorum_reached?
    cumulative_voting_power >= quorum_target
  end

  def yes_threshold_percentage
    threshold = non_abstain_voting_power * @proposal.chain.governance_params.tally_param_threshold
    round_if_whole((threshold / total_bonded) * 100, 2)
  end

  def current_win_threshold
    return Float::INFINITY if non_abstain_voting_power.zero?

    non_abstain_voting_power * @proposal.chain.governance_params.tally_param_threshold
  end

  def current_veto_threshold
    return Float::INFINITY if non_abstain_voting_power.zero?

    non_abstain_voting_power * @proposal.chain.governance_params.tally_param_veto
  end

  def voting_power_needed_for_yes
    current_win_threshold - raw_yes
  end

  def voting_power_needed_for_veto
    current_veto_threshold - raw_nowithveto
  end

  def percent_yes_to_win
    # to win, the amount of yes votes has to be more
    # than gov params threshold of all votes, except abstain
    target = current_win_threshold
    percentage = target.zero? ? 100 : (raw_yes / target) * 100
    round_if_whole([percentage.to_f, 100].min, 2)
  end

  def percent_no_to_win
    # to win, the amount of no + abstain + veto votes
    # has to be more than the gov params threshold
    target = current_win_threshold
    current = raw_abstain + raw_no + raw_nowithveto
    percentage = target.zero? ? 100 : (current / target) * 100
    round_if_whole([percentage.to_f, 100].min, 2)
  end

  def percent_abstain_to_win
    # to win, the amount of no + abstain + veto votes
    # has to be more than the gov params threshold
    target = current_win_threshold
    current = raw_abstain + raw_no + raw_nowithveto
    percentage = target.zero? ? 100 : (current / target) * 100
    round_if_whole([percentage.to_f, 100].min, 2)
  end

  def percent_nowithveto_to_win
    # to win, the amount of veto votes
    # has to be more than the gov params veto threshld
    target = current_veto_threshold
    percentage = target.zero? ? 100 : (raw_nowithveto / target) * 100
    round_if_whole([percentage.to_f, 100].min, 2)
  end

  def no_votes?
    cumulative_voting_power == 0
  end
end
