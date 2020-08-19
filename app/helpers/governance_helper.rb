module GovernanceHelper

  def filter_double_votes( votes )
    grouped = votes.group_by(&:account)
    grouped.entries.map do |account, votes|
      votes.sort_by(&:created_at).last
    end
  end

  def proposal_status_string( proposal, tally=nil )
    tally ||= @chain.namespace::ProposalTallyDecorator.new(proposal)

    if proposal.rejected?
      return "Proposal rejected."
    end

    if proposal.passed?
      return "Proposal passed."
    end

    if proposal.in_deposit_period?
      return "Waiting for deposits..."
    end

    if !tally.quorum_reached?
      return "Waiting to reach quorum <span class='text-muted text-sm'>(<span class='technical'>#{round_if_whole(tally.quorum_percentage * 100, 2)}%</span>)</span>..."
    end

    if tally.percent_nowithveto_to_win >= 100
      return "Proposal fails due to veto."
    end

    if tally.percent_yes_to_win >= 100
      return "Proposal passes."
    end

    return "Proposal fails."
  end

  def proposal_period_progress_percentage( proposal, period: )
    start_time = period == :voting ? proposal.voting_start_time : proposal.submit_time
    end_time = period == :voting ? proposal.voting_end_time : proposal.deposit_end_time
    total_time = end_time.to_i - start_time.to_i
    current_time_in_window = Time.now.to_i - start_time.to_i
    current_time_in_window / total_time.to_f
  end

  def total_deposits_for_proposal( proposal )
    proposal.total_deposits.map do |deposit|
      "#{deposit[:total_amount]} #{deposit[:denom]}"
    end.join('<br />').html_safe
  end

  def deposits_for_proposal_by_account( proposal, account )
    deposits = proposal.deposits.where( account: account )

    if deposits.any?
      grouped = deposits.group_by(&:amount_denom)
      tag.div do
        tag.label( class: 'd-block mb-1 text-muted' ) { 'Deposits:' } +
        grouped.map do |denom, deposits|
          tag.div( class: 'text-nowrap' ) do
            format_amount(deposits.sum(&:amount), proposal.chain, denom: denom)
          end
        end.join('').html_safe
      end
    end
  end

  def vote_for_proposal_by_account( proposal, account )
    vote = proposal.votes.where( account: account ).last
    if vote
      bg = case vote.option.downcase
           when 'yes' then 'success'
           when 'abstain' then 'secondary'
           when 'no' then 'danger'
           when 'nowithveto' then 'veto'
           end
      tag.span( class: "color-#{bg}" ) { vote.short_option.upcase }
    end
  end

end
