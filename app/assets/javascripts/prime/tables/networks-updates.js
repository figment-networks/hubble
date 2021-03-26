$(document).ready(function() {
  $('#networks_updates_table').DataTable({
    searching: false,
    pageLength: 5,
    paging: true,
    ordering: false,
    bLengthChange: false,
    info: false,
    initComplete: function(settings, json) {
      $('#networks_updates_table').wrap('<div style=\'overflow:auto; width:100%;position:relative;\'></div>');
    }
  });
});
