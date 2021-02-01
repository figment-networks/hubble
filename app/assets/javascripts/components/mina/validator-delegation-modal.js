class ValidatorDelegationModal {
  constructor(target) {
    this.delegateButton = $(target).find('button');
  }

  render() {
    this.delegateButton.on('click', function() {
      alert('Not supported yet!');
    });
  }
}

window.App.Mina.ValidatorDelegationModal = ValidatorDelegationModal;
