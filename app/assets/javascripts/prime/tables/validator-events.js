$(document).ready(function() {
  $('#validator_events').DataTable({
    searching: false,
    pageLength: 5,
    paging: true,
    ordering: false,
    bLengthChange: false,
    info: false,
    initComplete: function(settings, json) {
      $('#validator_events').wrap('<div style=\'overflow:auto; width:100%;position:relative;\'></div>');
    }
  });
});
