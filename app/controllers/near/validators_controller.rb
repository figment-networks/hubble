class Near::ValidatorsController < Near::BaseController
  def show
    @validator         = client.validator(params[:id])
    @performance_chart = generate_performance_chart(@validator.epochs)
  end

  private

  def generate_performance_chart(epochs = [])
    epochs.reverse.map do |epoch|
      { t: epoch.last_time.iso8601, y: epoch.efficiency.round(2) }
    end
  end
end
