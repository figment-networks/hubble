$(document).ready(function() {
  if (!_.includes(App.mode, 'validator-show')) {
    return;
  }

  new App.Celo.ValidatorScoreChart($('.validator-score-chart')).render();
  new App.Common.HourlyUptimeChart($('.validator-hourly-uptime-chart')).render();
});
