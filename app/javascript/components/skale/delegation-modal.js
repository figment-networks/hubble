import CommonDelegationModal from '../common/common-delegation-modal';
import Metamask from './metamask';

export default class DelegationModal extends CommonDelegationModal {
  constructor(target) {
    super(target, new Metamask());

    this.provider.setChainId(this.delegateButton.data('ethereum-chain-id'));

    this.minimumDelegationAmount = this.delegateButton.data('minimum-delegation-amount');

    this.delegateButton.on('click', () => this.showStep('.step-instructions'));
    this.modal.find('.start-delegation').on('click', () => this.startDelegation());

    window.ethereum.on('accountsChanged', async () => {
      if (this.modalVisible()) await this.startDelegation();
    });

    window.ethereum.on('chainChanged', async () => {
      if (this.modalVisible()) await this.startDelegation();
    });
  }

  async startDelegation() {
    this.showStep('.step-setup');

    try {
      this.accountAddress = await this.provider.setup();
      this.lockedAmount = await this.provider.fetchLockedAmount(this.accountAddress);
      this.accountBalance = await this.provider.fetchBalance(this.accountAddress);
      this.showNewDelegation();
    } catch (err) {
      this.showError(err);
    }
  }

  async fillNewDelegationForm(delegationStep) {
    delegationStep.find('.account-address').text(this.accountAddress);
    delegationStep.find('.account-balance').text(this.formatAmount(this.accountBalance));
    delegationStep.find('.account-locked-balance').text(this.formatAmount(this.lockedAmount));
    delegationStep.find('.minimum-delegation-amount').text(this.formatAmount(this.minimumDelegationAmount));
    const amountField = delegationStep.find('.delegation-amount');
    amountField.val(this.factoredAmount(this.maxDelegationAmount()));
    amountField.attr('max', this.factoredAmount(this.maxDelegationAmount()));
    amountField.attr('min', this.factoredAmount(this.minimumDelegationAmount));
  }

  async submitDelegation(e) {
    e.preventDefault();
    this.showStep('.step-confirm');
    this.amount = this.modal.find('.step-new-delegation .delegation-amount').val();
    try {
      await this.provider.signDelegation(this.validator, this.amount, this.tokenFactor);
      this.showComplete();
    } catch (err) {
      this.showError(err);
    }
  }

  maxDelegationAmount() {
    return this.accountBalance.sub(this.lockedAmount); // these are BigNumber instances
  }

  delegationPath() {
    return `${this.endpoint}/accounts/${this.accountAddress}`;
  }
}
