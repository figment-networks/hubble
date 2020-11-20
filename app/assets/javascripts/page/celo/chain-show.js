$(document).ready(function() {
  if (!_.includes(App.mode, 'chain-show')) {
    return;
  }

  new App.Celo.ValidatorGroupsTable($('.validator-groups-table'), ['state']).render();
  new App.Common.TransactionsVolumeChart($('.validator-groups-summary-chart'), {scale: true}).render();
  new App.Common.SmallAverageBlockTimeChart($('.average-block-time-chart')).render();
});
