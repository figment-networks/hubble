$(document).ready(function() {
  if (!_.includes(App.mode, 'validator-show')) {
    return;
  }

  new App.Common.BlocksHeatmap($('.validator-blocks-heatmap')).render();
  new App.Coda.ValidatorBalanceChart($('.validator-balance-chart')).render();
  new App.Coda.ValidatorDelegationModal($('.validator-ledger')).render();
});
