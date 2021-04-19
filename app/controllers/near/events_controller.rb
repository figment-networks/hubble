class Near::EventsController < Near::BaseController
  def index
    @current_events_page = params['events_page'].to_i || 1
    @events = client.paginate(Near::Event, '/events', { page: @current_events_page, limit: 50 })
    page_title 'Events'
    meta_description 'Events'
  end
end
