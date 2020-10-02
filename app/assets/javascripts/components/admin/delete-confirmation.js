$(document).ready(function() {
  $('.action-delete-confirmation').click(function(e) {
    const button = $(e.currentTarget);
    if (button.data('confirming')) {
      button.text('deleting...').addClass('disabled');
      return true;
    } else {
      e.preventDefault();
      button.data('confirming', true);
      button.data('old-html', button.html());
      button.html('<span class=\'fa fa-hourglass-half fa-spin\'></span> confirm? <span class=\'fa fa-bomb\'></span>');
      setTimeout(
          function() {
            button.data('confirming', false)
                .html(button.data('old-html'));
          },
          5000
      );
      return false;
    }
  });
});
