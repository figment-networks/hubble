$(document).ready(function() {
  $('#validators_performance').DataTable({
    searching: false,
    pageLength: 5,
    paging: true,
    ordering: false,
    bLengthChange: false,
    info: false,
    initComplete: function(settings, json) {
      $('#validators_performance').wrap('<div style=\'overflow:auto; width:100%;position:relative;\'></div>');
    }
  });
});
