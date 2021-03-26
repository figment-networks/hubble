$(document).ready(function() {
  $('#my_address_table').DataTable({
    searching: false,
    paging: true,
    ordering: false,
    bLengthChange: false,
    info: false,
    initComplete: function(settings, json) {
      $('#my_address_table').wrap('<div style=\'overflow:auto; width:100%;position:relative;\'></div>');
    }
  });
});
