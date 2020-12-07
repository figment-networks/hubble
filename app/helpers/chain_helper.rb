module ChainHelper
  def grouped_visible_chains
    @grouped_visible_chains ||=
      visible_chains.sort_by! { |chain| chain.network_name.downcase }.group_by(&:network_name)
  end

  def visible_chains
    Rails.application.eager_load! unless Rails.configuration.cache_classes
    ApplicationRecord.descendants.select { |ar_class| ar_class.name.ends_with?('::Chain') }.map do |chain_class|
      chains = chain_class.all
      chains = chain_class.has_synced if chain_class.respond_to?(:has_synced)
      chains = chains.alive if chain_class.respond_to?(:alive)
      if chain_class.respond_to?(:enabled) && !chain_class.included_modules.include?(Cosmoslike::Chainlike)
        chains = chains.enabled
      end
      chains.to_a
    end.flatten
  end

  def sort_chains(chains)
    chains.sort_by { |c| c.primary? ? 1.minute.from_now : (c.last_sync_time || Time.at(1)) }.reverse
  end

  def sorted_token_map(chain)
    chain.token_map.sort_by { |_k, v| v['primary'] ? -1 : 1 }.to_h
  end

  def chain_header_tooltip_info
    logs_path = namespaced_path('logs') if @chain.respond_to?('sync_logs')

    sync_time = @chain.last_sync_time ? "#{distance_of_time_in_words(Time.now,
                                                                     @chain.last_sync_time, true, highest_measures: 2)} ago" : 'Never'
    sync_interval = distance_of_time_in_words(@chain.class::SYNC_INTERVAL)

    [
      "<p><label class='text-muted'>Last synced:</label>#{sync_time}</p>",
      "<p><label class='text-muted'>Sync interval:</label>#{sync_interval}</p>",
      ("<div class='buttons'><a class='btn btn-sm btn-outline-primary' href='#{logs_path}'>View Log</a></div>" if logs_path)
    ].join('')
  end

  def chain_voting_power_online_percentage(chain)
    current = chain.voting_power_online
    total = chain.total_current_voting_power
    return 'Cannot calculate %' if total.zero?

    ((current.to_f / total.to_f) * 100).round(0).to_s + '%'
  end

  def show_datahub_promotion?(chain)
    [Cosmos::Chain, Terra::Chain, Near::Chain].include?(chain.class)
  end
end
