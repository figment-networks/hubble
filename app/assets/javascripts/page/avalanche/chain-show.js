$(document).ready(function() {
  if (!_.includes(App.mode, 'chain-show')) {
    return;
  }

  new App.Avalanche.ValidatorTable($('.validator-table')).render();
  new App.Common.TransactionsVolumeChart($('.validators-daily-stake-chart'), {scale: true}).render();
});
