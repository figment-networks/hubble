class Polkadot::ChainsController < Polkadot::BaseController
  def show
    status = client.status
    @height = status.last_block_height
    @latest_block_time = status.last_block_time
    @validators = client.validators
    @validator_daily_stake = client.validator_daily_stake.map do |validator_summary|
      Polkadot::ValidatorSummaryChartDecorator.new(validator_summary).point(@chain)
    end

    page_title 'Overview'
    meta_description 'Validators'
  end
end
