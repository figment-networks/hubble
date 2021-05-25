import {ethers} from 'ethers';
import {Contract} from '@ethersproject/contracts';
import {parseUnits} from 'ethers/lib/utils';

import DelegationAbi from './contracts/delegation-abi';
import Erc20Abi from './contracts/erc20-abi';
import {
  DELEGATION_CONTRACT_ADDRESS,
  SKALE_CONTRACT_ADDRESS,
  DELEGATION_PERIOD,
  CHAIN_NAME
} from './contracts/constants';

const DELEGATION_INFO = 'Hubble';

export default class Metamask {
  async setup() {
    if (typeof window.ethereum === 'undefined') {
      throw new Error('Staking in Hubble is supported via a MetaMask browser extension. ' +
        'Head to https://metamask.io to install');
    }

    if (await window.ethereum.request({method: 'eth_chainId'}) != this.chainId) {
      throw new Error(`Please switch your network in MetaMask to Ethereum ${CHAIN_NAME[this.chainId]}`);
    }

    const accounts = await window.ethereum.request({method: 'eth_requestAccounts'});
    this.delegationContract = this.setupDelegationContract();
    this.erc20Contract = this.setupErc20Contract();

    return accounts[0];
  }

  async fetchLockedAmount(account) {
    return await this.delegationContract.callStatic
        .getAndUpdateLockedAmount(account) || 0;
  }

  async fetchBalance(account) {
    return await this.erc20Contract.balanceOf(account) || 0;
  }

  async signDelegation(validatorId, amount, tokenFactor) {
    const tokenAmount = parseUnits(amount.toString(), tokenFactor).toString();
    const gasLimit = await this.delegationContract.estimateGas.delegate(validatorId,
        tokenAmount, DELEGATION_PERIOD[this.chainId], DELEGATION_INFO);

    return await this.delegationContract.delegate(validatorId,
        tokenAmount, DELEGATION_PERIOD[this.chainId], DELEGATION_INFO, {gasLimit});
  }

  setChainId(chainId) {
    this.chainId = chainId;
  }

  setupDelegationContract() {
    return new Contract(DELEGATION_CONTRACT_ADDRESS[this.chainId], DelegationAbi, this.signer());
  }

  setupErc20Contract() {
    return new Contract(SKALE_CONTRACT_ADDRESS[this.chainId], Erc20Abi, this.signer());
  }

  signer() {
    return new ethers.providers.Web3Provider(window.ethereum).getSigner();
  }
}
