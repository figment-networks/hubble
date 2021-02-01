class Avalanche::ChainsController < Avalanche::BaseController
  def show
    @status     = client.status
    @validators = client.validators
    @network_stats_daily = client.network_stats(bucket: 'd')
    @validators_daily_stake = client.validators_daily_stake.map do |validator_summary|
      Avalanche::SummaryChartDecorator.new(validator_summary).point(@chain)
    end

    page_title 'Overview'
    meta_description 'Validators'
  end

  def search
    flash[:warning] = 'Sorry, search on this network is currently unavailable!'
    redirect_to avalanche_chain_path(@chain)
  end
end
