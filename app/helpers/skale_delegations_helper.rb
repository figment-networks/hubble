module SkaleDelegationsHelper
  def lookup_delegation(delegation_summary)
    delegation_summary.each_with_object(Hash.new(0)) do |item, hash|
      hash[item.state] = item.amount
    end
  end

  DELEGATION_STATE_BADGES = {
    'ACCEPTED' => 'primary',
    'CANCELED' => 'secondary',
    'COMPLETED' => 'success',
    'DELEGATED' => 'primary',
    'REJECTED' => 'danger',
    'UNDELEGATION_REQUESTED' => 'warning'
  }.freeze

  def account_delegation_state_tab(state)
    "<span class=\"badge badge-#{DELEGATION_STATE_BADGES[state]} state-tab\">#{state.titleize}</span>"
  end
end
