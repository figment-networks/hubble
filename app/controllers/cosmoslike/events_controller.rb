class Cosmoslike::EventsController < Cosmoslike::BaseController

  def index
    @page = [params[:page].to_i, 1].max
    @offset = @chain.class::EVENTS_PAGE_SIZE * (@page - 1)

    events = @chain.events.includes(:validatorlike)

    if params[:validator] && (@validator = @chain.validators.find_by( address: params[:validator] ))
      events = events.where( validatorlike: @validator )
      page_title @chain.network_name, @chain.name, "Events for #{@validator.long_name}"
      meta_description "Validator events for #{@validator.name_and_owner} on #{@chain.network_name} - #{@chain.name}"
    else
      page_title @chain.network_name, @chain.name, 'Events'
      meta_description "Validator events for #{@chain.network_name} - #{@chain.name}"
    end

    @total = events.count
    @events = events
      .limit( @chain.class::EVENTS_PAGE_SIZE )
      .offset( @offset )
  end

  def show
    @event = @chain.events.find params[:id]
    @validator = @event.validatorlike
    page_title @chain.network_name, @chain.name, @event.page_title
    meta_description @event.page_title
  end

end
