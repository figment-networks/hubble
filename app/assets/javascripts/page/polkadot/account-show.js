$(document).ready(function() {
  if (!_.includes(App.mode, 'account-show')) {
    return;
  }

  new App.Polkadot.DelegationsTable($('.delegations-table')).render();
  new App.Polkadot.TransactionsTable($('.transactions-table')).render();
});
