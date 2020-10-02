$(document).ready(function() {
  if (!_.includes(App.mode, 'validator-show')) {
    return;
  }

  new App.Common.ValidatorBalanceChart($('.validator-daily-stake-chart')).render();
  new App.Common.HourlyUptimeChart($('.validator-hourly-uptime-chart')).render();
});
