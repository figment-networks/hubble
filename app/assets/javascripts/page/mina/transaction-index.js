$(document).ready(function() {
  if (!_.includes(App.mode, 'transaction-index')) {
    return;
  }

  flatpickr('.flatpickr', {
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

  $('a.load-more').on('click', function(e) {
    e.preventDefault();

    const button = $(this);
    const table = $('.transactions-search-results table');
    const tableBody = table.find('tbody');
    const lastRow = tableBody.find('tr:last-child');
    const limit = button.data('limit');
    const position = $(window).scrollTop();

    if (button.data('loading')) {
      return;
    } else {
      button.data('loading', true);
    }

    $('#search_before_id').val(lastRow.data('id'));

    const path = $(this).data('path');
    const data = $('form.new_search').serialize();

    $.get(path, data, function(resp) {
      button.data('loading', false);
      const rows = $(resp).find('tbody > tr');

      // Append new rows
      if (rows.length) {
        rows.appendTo('table > tbody');
        $(window).scrollTop(position);
      }

      // Update pagination text
      if (rows.length < limit) {
        const finished = $('<div/>').addClass('text-muted').text('No more transactions found');
        button.replaceWith(finished);
      }
    });
  });
});
