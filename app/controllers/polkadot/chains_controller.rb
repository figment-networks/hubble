class Polkadot::ChainsController < Polkadot::BaseController
  def show
    status = client.status
    @height = status.last_block_height
    @latest_block_time = status.last_block_time
    @validators = client.validators(status.indexed_validators_height)
    @validators_daily_stake = client.validators_daily_stake.map do |validator_summary|
      Common::SummaryChartDecorator.new(validator_summary).point(@chain)
    end

    page_title 'Overview'
    meta_description 'Validators'
  end

  def search
    flash[:warning] = 'Sorry, search on this network is currently unavailable!'
    redirect_to polkadot_chain_path(@chain)
  end
end
