$(document).ready(function() {
  if (!App.mode.includes('prime-home')) {
    return;
  }

  new App.Prime.EventsCalendar(document.getElementById('calendar')).render();
});
