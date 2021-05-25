import DelegationModal from '../../components/skale/delegation-modal';

$(document).ready(function() {
  if (!App.mode.includes('validator-show')) {
    return;
  };

  new DelegationModal('.stake-button');
});
