import Ledger from './ledger';
import {getAccountDetails, broadcastTransaction} from './requests';

class DelegationModal {
  constructor(target) {
    this.delegateButton = $(target);
    this.modal = $(this.delegateButton.data('modal'));
    this.validator = this.delegateButton.data('validator');
    this.endpoint = this.delegateButton.data('endpoint');
    this.tokenDisplay = this.delegateButton.data('token-display');
    this.tokenFactor = this.delegateButton.data('token-factor');
    this.testnet = this.delegateButton.data('testnet');
    this.fee = 1000000;
    this.ledger = new Ledger();

    this.delegateButton.on('click', () => this.startDelegation());
    this.modal.find('.account-form').on('submit', (e) => this.setAccountNumber(e));
    this.modal.find('.delegation-form').on('submit', (e) => this.submitDelegation(e));
  }

  async startDelegation() {
    this.showStep('.step-setup');
    this.modal.modal('show');

    try {
      await this.ledger.setupLedger();
      this.showStep('.step-account');
    } catch (err) {
      this.showError(err);
    }
  }

  async setAccountNumber(e) {
    e.preventDefault();
    this.accountNumber = parseInt(this.modal.find('[name=account-number]').val());
    this.showStep('.step-confirm-account');

    try {
      const accountAddressResponse = await this.ledger.accountAddress(this.accountNumber);
      this.accountAddress = accountAddressResponse.publicKey;
      if (!this.accountAddress) throw new Error('Failed to generate account public address');
      const accountDetails = await getAccountDetails(this.endpoint, this.accountAddress);
      this.accountBalance = accountDetails.balance;
      this.nonce = accountDetails.nonce ? parseInt(accountDetails.nonce) : 0;
      this.showNewDelegation();
    } catch (err) {
      this.showError(err);
    }
  }

  showNewDelegation() {
    const delegationStep = this.modal.find('.step-new-delegation');
    delegationStep.find('.account-address').text(this.accountAddress);
    delegationStep.find('.account-balance').text(this.formatAmount(this.accountBalance));
    delegationStep.find('.transaction-fee').text(this.formatAmount(this.fee));
    this.showStep('.step-new-delegation');
  }

  async submitDelegation(e) {
    e.preventDefault();
    this.showStep('.step-confirm');

    try {
      const signature = await this.ledger.signDelegation(this.accountNumber,
          this.accountAddress, this.validator, this.fee, this.testnet, this.nonce);
      this.transactionHash = await broadcastTransaction(
          this.endpoint, this.accountAddress, this.validator, this.fee,
          this.nonce, this.ledger.DELEGATION_MEMO, signature);
      this.showComplete();
    } catch (err) {
      this.showError(err);
    }
  }

  showComplete() {
    this.modal.find('.view-transaction').attr('href', this.transactionPath());
    this.showStep('.step-complete');
  }

  showStep(step) {
    this.hideSteps();
    this.modal.find(step).show();
  }

  hideSteps() {
    this.modal.find('.delegation-step').hide();
  }

  showError(error) {
    this.showStep('.step-error');
    this.modal.find('.delegation-error').text(error ? error : 'Unknown error.')
        .show();
  }

  formatAmount(amount) {
    return `${amount / (10 ** this.tokenFactor)} ${this.tokenDisplay}`;
  }

  transactionPath() {
    return `${this.endpoint}/transactions/${this.transactionHash}`;
  }
}

window.App.Mina.DelegationModal = DelegationModal;
