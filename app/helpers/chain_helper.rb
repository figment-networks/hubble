module ChainHelper

  def sort_chains( chains )
    chains.sort_by { |c| c.primary? ? 1.minute.from_now : (c.last_sync_time || Time.at(1)) }.reverse
  end

  def sorted_token_map( chain )
    chain.token_map.sort_by { |k,v| v['primary'] ? -1 : 1 }.to_h
  end

  def chain_header_tooltip_info
    logs_path = namespaced_path( 'logs' ) if @chain.respond_to?( 'sync_logs' )

    sync_time = @chain.last_sync_time ? "#{distance_of_time_in_words(Time.now, @chain.last_sync_time, true, highest_measures: 2)} ago" : 'Never'
    sync_interval = distance_of_time_in_words(@chain.class::SYNC_INTERVAL)

    [
      "<p><label class='text-muted'>Last synced:</label>#{sync_time}</p>",
      "<p><label class='text-muted'>Sync interval:</label>#{sync_interval}</p>",
      ("<div class='buttons'><a class='btn btn-sm btn-outline-primary' href='#{logs_path}'>View Log</a></div>" if logs_path)
    ].join('')
  end

  def chain_voting_power_online_percentage( chain )
    current = chain.voting_power_online
    total = chain.total_current_voting_power
    return 'Cannot calculate %' if total.zero?
    ((current.to_f / total.to_f) * 100).round(0).to_s + '%'
  end

end
