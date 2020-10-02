class Oasis::EventsController < Oasis::BaseController
  before_action :set_behind_chain_alert

  include Pagy::Backend

  def index
    if params[:validator]
      @validator = @chain.client.validator(params[:validator])
      events = @chain.client.validator_events(params[:validator])
      page_title @chain.network_name, @chain.name, "Events for #{@validator.address}"
      meta_description "Validator events for #{@validator.address} on #{@chain.network_name} - #{@chain.name}"
    else
      events = []
      page_title @chain.network_name, @chain.name, 'Events'
      meta_description "Validator events for #{@chain.network_name} - #{@chain.name}"
    end

    @pagy_a, @events = pagy_array(events, limit: @chain.class::EVENTS_PAGE_SIZE)
  end
end
