$(document).ready(function() {
  if (!_.includes(App.mode, 'dashboard')) {
    return;
  }


  $('.dashboard-accounts table').DataTable({
    'sDom': 'lrtip',
    'paging': false,
    'info': false,
    'autoWidth': false,
    'className': 'gov-proposals-table',
    'stripeClasses': ['even', 'odd'],
    'order': [],
    'columns': [
      {
        width: 'auto',
        className: 'col-address'
      },
      {
        width: 'auto',
        className: 'col-balance'
      },
      {
        width: 'auto',
        className: 'col-delegated'
      },
      {
        width: 'auto',
        className: 'col-pending'
      },
      {
        width: 'auto',
        className: 'col-total'
      }
    ]
  });

  const accountTotals = {
    balance: 0,
    delegated: 0,
    pending: 0,
    total: 0
  };
  $('.dashboard-accounts tbody tr').each(function() {
    const row = $(this);
    $.ajax({
      url: App.config.watchedAddressInfoPath.replace('ADDRESS', row.data('accountAddress')),
      type: 'GET',
      dataType: 'json',
      data: {dashboard_info: true},
      success: function(r) {
        console.log(r);
        const balance = parseFloat(_.find(r.balances, (b) => b.denom == App.config.remoteDenom).amount);
        const delegated = parseFloat(_.reduce(r.delegations, (acc, d) => acc + parseFloat(d.shares), 0));
        const pending = parseFloat(_.reduce(_.filter(r.rewards, (r) => r.denom == App.config.remoteDenom), (acc, r) => acc + parseFloat(r.amount), 0));
        const total = balance+delegated+pending;

        accountTotals.balance += balance;
        accountTotals.delegated += delegated;
        accountTotals.pending += pending;
        accountTotals.total += total;

        row.find('.account-balance').text(formatAmount(balance));
        row.find('.account-delegated').text(formatAmount(delegated));
        row.find('.account-pending-rewards').text(formatAmount(pending));
        row.find('.account-total').text(formatAmount(total));

        const totalsContainer = $('.dashboard-accounts tfoot tr:first-child');
        totalsContainer.find('td.total-balance').text(formatAmount(accountTotals.balance));
        totalsContainer.find('td.total-delegated').text(formatAmount(accountTotals.delegated));
        totalsContainer.find('td.total-pending-rewards').text(formatAmount(accountTotals.pending));
        totalsContainer.find('td.total-total').text(formatAmount(accountTotals.total));
      }
    });
  });
});

function formatAmount(amount) {
  amount /= App.config.remoteScaleFactor;
  if (amount % 1 != 0) {
    amount = amount.toFixed(3);
  }
  return `${amount} ${App.config.denom}`;
}
