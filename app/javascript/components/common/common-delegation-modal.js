class CommonDelegationModal {
  constructor(target, provider) {
    this.provider = provider;
    this.delegateButton = $(target);
    this.modal = $(this.delegateButton.data('modal'));
    this.validator = this.delegateButton.data('validator');
    this.tokenDisplay = this.delegateButton.data('token-display');
    this.tokenFactor = this.delegateButton.data('token-factor');
    this.endpoint = this.delegateButton.data('endpoint');

    this.modal.find('.delegation-form').on('submit', (e) => this.submitDelegation(e));
  }

  async startDelegation() {
    this.showStep('.step-setup');
    this.modal.modal('show');

    try {
      await this.provider.setup();
      this.showStep('.step-account');
    } catch (err) {
      this.showError(err);
    }
  }

  showNewDelegation() {
    const delegationStep = this.modal.find('.step-new-delegation');
    this.fillNewDelegationForm(delegationStep);
    this.showStep('.step-new-delegation');
  }

  showComplete() {
    this.modal.find('.view-delegation').attr('href', this.delegationPath());
    this.showStep('.step-complete');
  }

  modalVisible() {
    return this.modal.is(':visible');
  }

  showStep(step) {
    this.hideSteps();
    this.modal.find(step).show();
    if (!this.modalVisible()) this.modal.modal('show');
  }

  hideSteps() {
    this.modal.find('.delegation-step').hide();
  }

  showError(error) {
    this.showStep('.step-error');
    const message = error.message || error || 'Unknown error.';
    this.modal.find('.delegation-error').text(message).show();
  }

  formatAmount(amount) {
    return `${this.factoredAmount(amount)} ${this.tokenDisplay}`;
  }

  factoredAmount(amount) {
    return amount / (10 ** this.tokenFactor);
  }
}

export default CommonDelegationModal;
