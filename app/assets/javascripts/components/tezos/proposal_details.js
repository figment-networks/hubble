$(document).ready(function() {

  $("#description-button").click(function(){
    $("#description").toggle("slow");
    $(this).text( $(this).text() == 'SHOW' ? 'HIDE' : 'SHOW' );
  });
});
