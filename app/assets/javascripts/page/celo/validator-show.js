$(document).ready(function() {
  if (!_.includes(App.mode, 'validator-show')) {
    return;
  }

  new App.Common.BlocksHeatmap($('.validator-blocks-heatmap')).render();
  new App.Celo.ValidatorScoreChart($('.validator-score-chart')).render();
  new App.Common.HourlyUptimeChart($('.validator-hourly-uptime-chart')).render();
});
