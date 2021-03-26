class Avalanche::ChainsController < Avalanche::BaseController
  def show
    @status     = client.status
    @validators = client.validators
    @network_stats_daily = client.network_stats(bucket: 'd')
    @staking_participation_stats = staking_participation_stats
    @validators_daily_stake = validator_stake_stat_fetcher('d')
    @validators_hourly_stake = validator_stake_stat_fetcher('h')

    page_title 'Overview'
    meta_description 'Validators'
  end

  def search
    flash[:warning] = 'Sorry, search on this network is currently unavailable!'
    redirect_to avalanche_chain_path(@chain)
  end

  private

  def validator_stake_stat_fetcher(interval)
    client.validators_stake(bucket: interval).map do |validator_summary|
      Avalanche::SummaryChartDecorator.new(validator_summary).point(@chain)
    end
  end

  def staking_participation_stats
    staking_participation = client.network_stats(bucket: 'd')
    Avalanche::StatsChartDecorator.new(staking_participation)
  end
end
