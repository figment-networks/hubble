import '../../components/mina/delegation-modal';

$(document).ready(function() {
  if (!App.mode.includes('validator-show')) {
    return;
  }

  new App.Mina.DelegationModal($('.stake-button'));
});
