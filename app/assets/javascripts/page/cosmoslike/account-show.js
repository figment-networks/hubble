$(document).ready(function() {
  if (!_.includes(App.mode, 'account-show')) {
    return;
  }

  new App.Cosmoslike.DelegationsTable($('.delegations-table')).render();

  const table = $('.transactions-table').find('table');
  const isEmpty = table.data('empty');

  table.DataTable({
    'sDom': 'lrtip',
    'paging': false,
    'info': false,
    'autoWidth': false,
    'className': 'transactions-table',
    'order': isEmpty ? [] : [[1, 'desc'], [2, 'desc']],
    'columns': isEmpty ? [{width: '45%'}] : _.compact([
      {
        width: 'auto',
        className: 'col-hash'
      },
      {
        width: '140px',
        className: 'col-height'
      },
      {
        width: '150px',
        className: 'col-type'
      },
      {
        width: '110px',
        className: 'col-buttons',
        orderable: false
      }
    ])
  });

  $('.copy-button').each(function() {
    const copyButton = $(this);
    if (ClipboardJS.isSupported()) {
      copyButton.show();
      const clipboard = new ClipboardJS(
          copyButton.get(0),
          {text: (() => copyButton.data('hash'))}
      );
      clipboard.on('success', function() {
        copyButton.html('<span class=\'fa fa-check\'></span>');
        setTimeout((() => copyButton.html('<span class=\'fa fa-copy\'></span>')), 2000);
      });
    } else {
      copyButton.attr('disabled', 'disabled');
    }
  });

  const rewardsContainers = $('.rewards');
  $('.report-currency-select').change(function() {
    const newDenom = $(this).val();
    const rewardsContainer = rewardsContainers.filter(`.denom-${newDenom}`);
    rewardsContainer.find('select').val(newDenom);
    rewardsContainers.not(rewardsContainer).addClass('d-none');
    rewardsContainer.removeClass('d-none');
  });
});
