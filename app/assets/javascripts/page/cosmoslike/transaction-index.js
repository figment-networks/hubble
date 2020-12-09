$(document).ready(function() {
  if (!_.includes(App.mode, 'transaction-index')) {
    return;
  }

  flatpickr('.flatpickr', {
    allowInput: true,
    onReady: function(dateObj, dateStr, instance) {
      const $cal = $(instance.calendarContainer);
      if ($cal.find('.flatpickr-clear').length < 1) {
        $cal.append('<div class="flatpickr-clear">Clear Selection</div>');
        $cal.find('.flatpickr-clear').on('click', function() {
          instance.clear();
          instance.close();
        });
      }
    }
  });
});
