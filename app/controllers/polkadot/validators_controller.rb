class Polkadot::ValidatorsController < Polkadot::BaseController
  include Pagy::Backend

  def show
    @validator = client.validator(params[:id])
    raise ActiveRecord::RecordNotFound unless @validator

    @validator_daily_stake = client.validator_daily_stake(@validator.stash_account).map do |validator_summary|
      Common::SummaryChartDecorator.new(validator_summary).point(@chain)
    end
    @validator_hourly_uptime = client.validator_hourly_uptime(@validator.stash_account).map do |validator_summary|
      Common::UptimeChartDecorator.new(validator_summary).point
    end
    events = client.validator_events(chain: @chain, address: params[:id], types: params[:types],
                                     start_date: params[:start_date], end_date: params[:end_date])
    @pagination, @events = pagy_array(events)
  end
end
