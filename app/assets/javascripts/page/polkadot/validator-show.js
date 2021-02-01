$(document).ready(function() {
  if (!_.includes(App.mode, 'validator-show')) {
    return;
  }

  // This prevents filter dropdown menu closing when filling in the form
  $('.validator-show .dropdown-menu').on('click', function(e) {
    e.stopPropagation();
  });

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

  new App.Common.ValidatorBalanceChart($('.validator-daily-stake-chart'), {scale: true}).render();
  new App.Common.HourlyUptimeChart($('.validator-hourly-uptime-chart')).render();
});
