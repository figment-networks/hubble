$(document).ready(function() {
  if (!_.includes(App.mode, 'delegator-list-report-show')) {
    return;
  }

  new App.Livepeer.DelegatorListReportTable($('.report-table')).render();
});
