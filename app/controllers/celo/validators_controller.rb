class Celo::ValidatorsController < Celo::BaseController
  def show
    @validator = client.validator(params[:id])
    raise ActiveRecord::RecordNotFound unless @validator

    @validator_scores = client.validator_daily_score(@validator.address).map do |validator_summary|
      Common::SummaryChartDecorator.new(validator_summary).point(@chain)
    end
    @validator_hourly_uptime = client.validator_hourly_uptime(@validator.address).map do |validator_summary|
      Common::UptimeChartDecorator.new(validator_summary).point
    end
  end
end
