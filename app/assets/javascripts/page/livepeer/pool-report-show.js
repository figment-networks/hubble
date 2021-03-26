$(document).ready(function() {
  if (!_.includes(App.mode, 'pool-report-show')) {
    return;
  }

  new App.Livepeer.PoolReportTable($('.report-table')).render();
});
