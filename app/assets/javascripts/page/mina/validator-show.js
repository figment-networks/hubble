$(document).ready(function() {
  if (!_.includes(App.mode, 'validator-show')) {
    return;
  }

  new App.Common.BlocksHeatmap($('.validator-blocks-heatmap')).render();
  new App.Mina.ValidatorBalanceChart($('.validator-balance-chart')).render();
  new App.Mina.ValidatorDelegationModal($('.validator-ledger')).render();
});
