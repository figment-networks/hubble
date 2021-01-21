class Polkadot::ValidatorsController < Polkadot::BaseController
  include Pagy::Backend

  def show
    @validator = client.validator(params[:id])
    raise ActiveRecord::RecordNotFound unless @validator

    events = client.validator_events(@chain, params[:id]).sort_by(&:time).reverse
    @validator_daily_stake = client.validator_daily_stake(@validator.stash_account).map do |validator_summary|
      Common::SummaryChartDecorator.new(validator_summary).point(@chain)
    end
    @validator_hourly_uptime = client.validator_hourly_uptime(@validator.stash_account).map do |validator_summary|
      Common::UptimeChartDecorator.new(validator_summary).point
    end
    @pagination, @events = pagy_array(events)
  end
end
