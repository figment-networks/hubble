import {MinaLedgerJS, TxType, Networks} from 'mina-ledger-js';
import TransportWebUSB from '@ledgerhq/hw-transport-webusb';

class Ledger {
  constructor(transport = TransportWebUSB) {
    this.transport = transport;
    this.LEDGER_INTERVAL_MS = 1500;
    this.DELEGATION_MEMO = 'https://hubble.figment.io';
  }

  async setupLedger() {
    if (!await this.transport.isSupported()) {
      throw new Error('Your browser does not support WebUSB, please use a ' +
        'Chromium-based browser like Chrome, Brave or Edge to stake ' +
        'Mina with Ledger');
    }
    while (!await this.setupLedgerLoop()) {
      await new Promise((resolve) => setTimeout(resolve, this.LEDGER_INTERVAL_MS));
    }
  }

  async setupLedgerLoop() {
    this.instance = new MinaLedgerJS(await this.transport.create());
    const appNameResponse = await this.instance.getAppName();
    return appNameResponse.name === 'Mina';
  }

  async accountAddress(accountNumber) {
    return await this.instance.getAddress(accountNumber);
  }

  async signDelegation(accountNumber, accountAddress, validator, fee, testnet, nonce) {
    const transaction = {
      txType: TxType.DELEGATION,
      senderAccount: accountNumber,
      senderAddress: accountAddress,
      receiverAddress: validator,
      amount: 0,
      fee: fee,
      nonce: nonce,
      memo: this.DELEGATION_MEMO,
      networkId: (testnet ? Networks.DEVNET : Networks.MAINNET)
    };

    const response = await this.instance.signTransaction(transaction);

    if (!response.signature) {
      throw new Error(response.message);
    }

    return response.signature;
  }
}

export default Ledger;
