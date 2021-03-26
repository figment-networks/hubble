$(document).ready(function() {
  $('#types-button').click(function() {
    $('#types').toggle('slow');
    $(this).text($(this).text() == 'SHOW' ? 'HIDE' : 'SHOW');
  });
});
