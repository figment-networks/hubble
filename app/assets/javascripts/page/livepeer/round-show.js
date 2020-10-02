$(document).ready(function() {
  if (!_.includes(App.mode, 'round-show')) {
    return;
  }

  new App.Livepeer.PoolsTable($('.pools-table')).render();
});
