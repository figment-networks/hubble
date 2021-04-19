$(document).ready(function() {
  if (!_.includes(App.mode, 'chain-show')) {
    return;
  }
  new App.Skale.ValidatorTable($('.validator-table')).render();
});
