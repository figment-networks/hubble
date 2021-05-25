import CommonDelegationModal from '../common/common-delegation-modal';
import Ledger from './ledger';
import {getAccountDetails, broadcastTransaction} from './requests';

export default class DelegationModal extends CommonDelegationModal {
  constructor(target) {
    super(target, new Ledger());

    this.testnet = this.delegateButton.data('testnet');
    this.fee = 1000000;

    this.delegateButton.on('click', () => this.startDelegation());
    this.modal.find('.account-form').on('submit', (e) => this.setAccountNumber(e));
  }

  async setAccountNumber(e) {
    e.preventDefault();
    this.accountNumber = parseInt(this.modal.find('[name=account-number]').val());
    this.showStep('.step-confirm-account');

    try {
      const accountAddressResponse = await this.provider.accountAddress(this.accountNumber);
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

  fillNewDelegationForm(delegationStep) {
    delegationStep.find('.account-address').text(this.accountAddress);
    delegationStep.find('.account-balance').text(this.formatAmount(this.accountBalance));
    delegationStep.find('.transaction-fee').text(this.formatAmount(this.fee));
  }

  async submitDelegation(e) {
    e.preventDefault();
    this.showStep('.step-confirm');

    try {
      const signature = await this.provider.signDelegation(this.accountNumber,
          this.accountAddress, this.validator, this.fee, this.testnet, this.nonce);
      this.transactionHash = await broadcastTransaction(
          this.endpoint, this.accountAddress, this.validator, this.fee,
          this.nonce, this.provider.DELEGATION_MEMO, signature);
      this.showComplete();
    } catch (err) {
      this.showError(err);
    }
  }

  delegationPath() {
    return `${this.endpoint}/transactions/${this.transactionHash}`;
  }
}
