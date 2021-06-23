module Prime::RewardsHelper
  PAYOUT_DISPLAY_TIMEFRAME = 30.days.freeze

  def network_reward_total(network)
    total_rewards = 0
    factor = network.primary.reward_token_factor
    current_user.prime_accounts.for_network(network.id).includes([:network]).each do |account|
      total_rewards += (account.rewards.sum(&:amount) / (10 ** factor))
    end
    total_rewards
  end

  def factored_amount(reward)
    reward.amount.to_f / (10 ** reward.token_factor)
  end

  def usd_equivalent(reward)
    if reward.token_display == reward.account.network.primary.reward_token_display
      return number_to_currency(reward_in_usd(reward.time, [reward], reward.account.network))
    elsif reward.token_display == 'USD'
      return number_to_currency(reward.amount.to_f / (10 ** reward.account.network.primary.reward_token_factor))
    else
      return nil
    end
  end

  def payout_display_time
    Time.now - PAYOUT_DISPLAY_TIMEFRAME
  end

  def build_reward_history_chart_data
    series = []
    enabled_networks.each do |network|
      network_rewards = user_rewards.select { |reward| reward.account.network.id == network.id }
      daily_rewards = network_rewards.group_by_day(&:time).map { |k, v| [k, reward_in_usd(k, v, network)] }
      monthly_rewards = daily_rewards.group_by_month { |day| day[0] }.map { |k, v| [k, v.sum { |r| r[1] }] }
      series << {
        name: network.name.capitalize,
        data: monthly_rewards
      }
    end
    series
  end

  def reward_history_chart_options
    {
      stacked: true,
      tooltip: tooltips_to_usd,
      yaxis: labels_to_usd,
      data_labels: false,
      stroke: { curve: 'smooth', width: 3 }
    }
  end

  private

  def reward_in_usd(time, reward_group, network)
    # TO DO - what to return if no pricing available??
    formatted_time = format_reward_timestamp(time)
    if network.daily_price_series_hash.has_key? formatted_time
      (network.daily_price_series_hash[formatted_time] || 0) * reward_group.sum(&:amount) / (10 ** network.primary.reward_token_factor)
    else
      0
    end
  end

  def format_reward_timestamp(time)
    time.to_s.split(' ').first
  end
end
