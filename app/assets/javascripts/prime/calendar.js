class EventsCalendar {
  constructor(target) {
    this.target = target;
  }

  render() {
    const calendar = new FullCalendar.Calendar(this.target, {
      initialView: 'dayGridMonth',
      eventColor: '#111',
      showNonCurrentDates: false,
      fixedWeekCount: false,
      events: App.seed.CALENDAR_EVENTS,
      eventClick: function(event) {
        if (event.event.url) {
          event.jsEvent.preventDefault();
          window.open(event.event.url, '_blank');
        }
      }
    });
    calendar.render();
  };
};

window.App.Prime.EventsCalendar = EventsCalendar;
