class Near::ValidatorsController < Near::BaseController
  include Pagy::Backend

  def show
    @validator = client.validator(params[:id])
    @performance_chart = generate_performance_chart(@validator.epochs)
    delegations = client.delegations(params[:id])
    epochs = @validator.epochs
    @pagination_delegations, @delegations = pagy_array(delegations, page_param: :delegations_page, items: 5)
    @pagination_epochs, @epochs = pagy_array(epochs, page_param: :epochs_page, items: 5)

    @current_events_page = params['events_page'].to_i || 1
    @events = client.paginate(Near::Event, '/events', { item_id: params[:id], item_type: 'validator', page: @current_events_page, limit: 5 })
  end

  private

  def generate_performance_chart(epochs = [])
    epochs.reverse.map do |epoch|
      { t: epoch.last_time.iso8601, y: epoch.efficiency.round(2) }
    end
  end
end
