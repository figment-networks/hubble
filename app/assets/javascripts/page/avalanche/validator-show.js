$(document).ready(function() {
  if (!_.includes(App.mode, 'validator-show')) {
    return;
  }
  new App.Common.HourlyUptimeChart($('.validator-hourly-uptime-chart')).render();
});
