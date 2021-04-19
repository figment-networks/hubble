class Celo::ValidatorsController < Celo::BaseController
  SEQUENCES_LIMIT = 50

  def show
    @validator = client.validator(params[:id], SEQUENCES_LIMIT)
    raise ActiveRecord::RecordNotFound unless @validator

    @validator_scores = client.validator_daily_score(@validator.address).map do |validator_summary|
      Celo::ScoresChartDecorator.new(validator_summary).point
    end
    @validator_hourly_uptime = client.validator_hourly_uptime(@validator.address).map do |validator_summary|
      Common::UptimeChartDecorator.new(validator_summary).point
    end
  end
end
