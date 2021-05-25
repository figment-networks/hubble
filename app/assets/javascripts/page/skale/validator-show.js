$(document).ready(function() {
  if (!_.includes(App.mode, 'validator-show')) {
    return;
  }
  new App.Skale.StakedTimeChart($('.staked-time-chart'), {scale: true}).render();
  new App.Skale.NodeTable($('.node-table')).render();
});
