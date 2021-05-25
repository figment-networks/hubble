import DelegationModal from '../../components/mina/delegation-modal';

$(document).ready(function() {
  if (!App.mode.includes('validator-show')) {
    return;
  }

  new DelegationModal('.stake-button');
});
