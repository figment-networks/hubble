module Prime::PortfoliosHelper
  def portfolio_balance_usd(networks, network_token_balances)
    return 0 if network_token_balances.values.inject(:+) == 0

    balance = 0
    networks.each do |network|
      balance += network.price_usd * network_token_balances[network.name]
    end
    balance.round(2)
  end

  def portfolio_one_month_roi(networks, network_token_balances)
    return 0 if network_token_balances.values.inject(:+) == 0

    networks.sum do |network|
      (network.one_month_roi * network_token_balances[network.name] * network.price_usd) / portfolio_balance_usd(networks, network_token_balances)
    end.round(2)
  end

  def build_portfolio_chart_data(networks, network_token_balances)
    networks = networks.select { |n| network_token_balances[n.name] > 0 }

    data = networks.map do |network|
      {
        name: network.name.capitalize,
        data: (network_token_balances[network.name] * network.price_usd).round(2)
      }
    end
  end

  def build_portfolio_timeseries_data(networks, network_token_balances)
    networks = networks.select { |n| network_token_balances[n.name] > 0 }

    data = networks.map do |network|
      period_values = {}
      network.tohlcv_values.each do |period|
        period_values[timestamp_to_date(period[0])] = (period[4] * network_token_balances[network.name]).round(2)
      end

      {
        name: network.name.capitalize,
        data: period_values
      }
    end
  end

  def tooltips_to_usd
    { y: { formatter: { function: { args: 'val', body: "return '$' + parseFloat(val).toLocaleString();" } } } }
  end

  def labels_to_usd
    { labels: { formatter: { function: { args: 'val', body: "return '$' + parseFloat(val).toLocaleString();" } } } }
  end

  private

  def timestamp_to_date(stamp)
    stamp /= 1000
    DateTime.strptime(stamp.to_s, '%s')
  end
end
