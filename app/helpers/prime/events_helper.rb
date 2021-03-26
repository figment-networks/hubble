module Prime::EventsHelper
  def build_calendar_events_array(events)
    events.each.map do |event|
      {
        title: event.network.name.capitalize,
        start: event.event_date,
        allDay: true,
        url: event.source
      }
    end
  end
end
