class Cosmoslike::EventsController < Cosmoslike::BaseController
  include Pagy::Backend

  def index
    events = @chain.events.includes(:validatorlike)

    if params[:validator] && (@validator = @chain.validators.find_by(address: params[:validator]))
      events = events.where(validatorlike: @validator)
      page_title @chain.network_name, @chain.name, "Events for #{@validator.long_name}"
      meta_description "Validator events for #{@validator.name_and_owner} on #{@chain.network_name} - #{@chain.name}"
    else
      page_title @chain.network_name, @chain.name, 'Events'
      meta_description "Validator events for #{@chain.network_name} - #{@chain.name}"
    end

    @pagy, @events = pagy(events, size: [1, 0, 0, 1])
  end

  def show
    @event = @chain.events.find params[:id]
    @validator = @event.validatorlike
    page_title @chain.network_name, @chain.name, @event.page_title
    meta_description @event.page_title
    @more_events_count = @chain.events.where(validatorlike: @validator).where('timestamp > ?',
                                                                              @event.timestamp).count
  end
end
