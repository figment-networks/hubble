$(document).ready(function() {
  if (!_.includes(App.mode, 'block-show')) {
    return;
  }

  new App.Oasis.ValidatorTable($('.validator-table'), ['precommits']).render();
  new App.Cosmoslike.TransactionsTable($('.transactions-table')).render();
});
