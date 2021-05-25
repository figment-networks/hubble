$(document).ready(function() {
  if (!_.includes(App.mode, 'account-show')) {
    return;
  }
  new App.Skale.AccountTable($('.account-table')).render();
  new App.Skale.AccountDataTable($('.account-data-table')).render();
});
