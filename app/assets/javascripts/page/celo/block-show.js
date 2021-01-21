$(document).ready(function() {
  if (!_.includes(App.mode, 'block-show')) {
    return;
  }

  new App.Celo.ValidatorGroupsTable($('.validator-groups-table'), ['state']).render();
});
