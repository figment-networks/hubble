$(document).ready(function() {
  if (!_.includes(App.mode, 'validator-group-show')) {
    return;
  }

  new App.Celo.ValidatorTable($('.validator-table')).render();
});
