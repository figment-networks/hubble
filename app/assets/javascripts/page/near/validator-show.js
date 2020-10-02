$(document).ready(function() {
  if (!_.includes(App.mode, 'validator-show')) {
    return;
  }

  new App.Near.ValidatorEpochsTable($('.validator-epochs-table')).render();
  new App.Near.ValidatorEpochsPerformanceChart($('.validator-epochs-performance-chart')).render();
  new App.Near.ValidatorBlocksHeatmap($('.validator-blocks-heatmap')).render();
});
