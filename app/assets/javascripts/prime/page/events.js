$(document).ready(function() {
  if (!App.mode.includes('prime-events')) {
    return;
  }

  new App.Prime.EventsCalendar(document.getElementById('calendar')).render();
});
