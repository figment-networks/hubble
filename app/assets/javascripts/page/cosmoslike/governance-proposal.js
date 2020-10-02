$(document).ready(function() {
  if (!_.includes(App.mode, 'governance-proposal')) {
    return;
  }

  new App.Cosmoslike.GovProposalDepositModal($('#proposal-deposit-modal'));
  new App.Cosmoslike.GovProposalVoteModal($('#proposal-vote-modal'));
});
