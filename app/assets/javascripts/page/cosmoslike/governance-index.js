$(document).ready(function() {
  if (!_.includes(App.mode, 'governance-index')) {
    return;
  }

  new App.Cosmoslike.GovProposalsTable($('.gov-proposals-table')).render();
  new App.Cosmoslike.GovProposalSubmitModal($('#proposal-modal'));
});
