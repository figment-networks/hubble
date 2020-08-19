module ValidatorHelper

  def event_kind_to_name( kind )
    case kind
    when 'voting_power_change' then 'Voting Power Change %'
    when 'active_set_inclusion' then 'Joined/Left the Active Set'
    when 'n_of_m' then 'Misses N of Last M Precommits'
    when 'n_consecutive' then 'Misses N Consecutive Precommits'
    when 'reward_cut_change' then 'Reward Cut Change'
    end
  end

  def event_kind_to_class( kind )
    "Common::ValidatorEvents::#{kind.classify}".constantize
  end

end
