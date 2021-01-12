module TezosHelper
  include Pagy::Frontend

  def event_icon(type)
    case type
    when 'missed_bake' then 'fa-bread-slice'
    when 'steal' then 'fa-mask'
    when 'missed_endorsement' then 'fa-check-double'
    when 'double_bake' then 'fa-exclamation'
    when 'double_endorsement' then 'fa-exclamation'
    when 'baker_activated' then 'fa-toggle-on'
    when 'baker_deactivated' then 'fa-toggle-off'
    end
  end

  def tezos_chain_path(*_args)
    tezos_root_path
  end

  def search_tezos_chain_path(*_args)
    tezos_root_path
  end

  def tezos_chain_dashboard_path(*_args)
    tezos_dashboard_path
  end

  def tezos_chain_baker_subscriptions_path(*args)
    tezos_baker_subscriptions_path(args[1].address)
  end

  def tezos_proposal_status_string(proposal, period, votes)
    if proposal.status == 'promoted'
      return 'Proposal successfully promoted.'
    elsif proposal.status == 'rejected'
      string = 'Proposal was rejected'
      if !proposal.passed_prop_period
        string += ' in the proposal period.'
      elsif !proposal.passed_eval_period
        string += ' in the evaluation period.'
      else
        string += ' in the promotion period.'
      end
      return string
    elsif period.period_type.in?(%w[promotion_vote evaluation_vote])
      string = 'In ' + period.period_type.titleize.downcase + ' period. '
      voted = votes.sum { |v| v.rolls }
      if voted >= period.quorum
        string += 'Quorum reached, waiting on voting results.'
      else
        string += "Waiting to reach quorum <span class='text-muted text-sm'>(<span class='technical'>#{round_if_whole(
          (voted.to_f / period.quorum.to_f) * 100, 2
        )}%</span>)</span>."
      end
      return string
    elsif period.period_type == 'testing'
      return 'In proposal testing period.'
    else
      return 'In proposal period voting.'
    end
  end

  def tezos_proposal_period_progress_percentage(period)
    start = DateTime.parse(period.period_start_time).to_f
    end_time = DateTime.parse(period.end_time_approximation).to_f
    percent = [1] << ((DateTime.now.to_f - start) / (end_time - start))
    return percent.min
  end
end
