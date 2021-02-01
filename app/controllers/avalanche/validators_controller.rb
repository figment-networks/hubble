class Avalanche::ValidatorsController < Avalanche::BaseController
  def show
    @validator = client.validator(params[:id])
    raise ActiveRecord::RecordNotFound unless @validator

    @validator_hourly_uptime_avg = client.validator(@validator.validator.node_id).stats_24h.map do |validator_stats_summary|
      Avalanche::UptimeChartDecorator.new(validator_stats_summary).point
    end
  end
end
