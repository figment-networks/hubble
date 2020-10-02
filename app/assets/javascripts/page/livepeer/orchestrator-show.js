$(document).ready(function() {
  if (!_.includes(App.mode, 'orchestrator-show')) {
    return;
  }

  new App.Livepeer.DelegatorsTable($('.delegators-table')).render();
});
