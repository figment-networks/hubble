class Polkadot::ValidatorsController < Polkadot::BaseController
  def show
    @validator = client.validator(params[:id])
    raise ActiveRecord::RecordNotFound unless @validator

    @validator_daily_stake = client.validator_daily_stake(@validator.stash_account).map do |validator_summary|
      Polkadot::SummaryChartDecorator.new(validator_summary).point(@chain)
    end
    @validator_hourly_uptime = client.validator_hourly_uptime(@validator.stash_account).map do |validator_summary|
      Polkadot::UptimeChartDecorator.new(validator_summary).point
    end
  end
end
