$(document).ready(function() {
  const rewardTable = $('#rewards_history_table').DataTable({
    searching: true,
    pageLength: 10,
    paging: true,
    ordering: false,
    bLengthChange: false,
    info: false,
    initComplete: function() {
      positionTableFilters();
      $('#rewards_history_table').wrap('<div style=\'overflow:auto; width:100%;position:relative;\'></div>');
    }
  });


  function positionTableFilters() {
    const datepicker = document.getElementById('date_filter_wrapper');
    const tableFilters = document.getElementById('rewards_history_table_filter');
    document.querySelector('.table-filters').remove();
    tableFilters.appendChild(datepicker);
  }

  $('#datepicker_from').datepicker({
    'onSelect': function(date) {
      minDateFilter = new Date(date).getTime();
      rewardTable.draw();
    }
  }).keyup(function() {
    minDateFilter = new Date(this.value).getTime();
    rewardTable.draw();
  });

  $('#datepicker_to').datepicker({
    'onSelect': function(date) {
      maxDateFilter = new Date(date).getTime();
      rewardTable.draw();
    }
  }).keyup(function() {
    maxDateFilter = new Date(this.value).getTime();
    rewardTable.draw();
  });
});

// Date range filter
minDateFilter = '';
maxDateFilter = '';

$.fn.dataTableExt.afnFiltering.push(
    function(oSettings, aData, iDataIndex) {
      if (typeof aData._date == 'undefined') {
        aData._date = new Date(aData[0]).getTime();
      }

      if (minDateFilter && !isNaN(minDateFilter)) {
        if (aData._date < minDateFilter) {
          return false;
        }
      }

      if (maxDateFilter && !isNaN(maxDateFilter)) {
        if (aData._date > maxDateFilter) {
          return false;
        }
      }

      return true;
    }
);
