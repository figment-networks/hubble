// = require lib/elliptic
// = require lib/bops
// = require bn.js/lib/bn
// = require lib/bech32
// = require lib/chrome-u2f-api
// = require lib/ledger
// = require crypto-js/crypto-js
// = require crypto-js/enc-hex
// = require crypto-js/sha256
// = require crypto-js/ripemd160


const HD_PATH = [44, 118, 0, 0, 0];

class Ledger {
  constructor() {
    this.LEDGER_TIMEOUT_MS = 5000;
    this.LEDGER_INTERVAL_MS = 1500;
    this.EC = elliptic.ec('secp256k1');
  }

  setupLedger() {
    return new Promise((resolve) => {
      this.setupCb = resolve;
      this.setupLedgerLoop();
    });
  }

  async setupLedgerLoop() {
    const scheduleCheck = () => {
      // go again if we aren't done setup
      if (!this.accountInfo) {
        setTimeout(() => this.setupLedgerLoop(), this.LEDGER_INTERVAL_MS);
      }
    };

    if (!this.device) {
      const conn = await window.ledger.comm_u2f.create_async(this.LEDGER_TIMEOUT_MS, true);
      this.device = new window.ledger.App(conn);
      scheduleCheck();
    } else {
      const versionResponse = await this.device.get_version();
      const pkResponse = await this.device.publicKey(HD_PATH);

      try {
        this.pk = this.device.compressPublicKey(pkResponse.pk);
      } catch (e) {
        // this is ok, it just means we haven't connected yet
        // console.error( "Could not compress public key.", e )
        scheduleCheck();
        return;
      }

      const address = this.getAddressFromPublicKey(this.pk);
      // console.log( 'ledger', { pk: pkResponse.pk, cpk: this.pk, address } )

      const addressInfoURL = `${App.config.addressInfoPathTemplate.replace('ADDRESS', address)}?validator=${App.config.validatorOperatorAddress}`;
      const addressInfoResponse = await fetch(addressInfoURL, {
        method: 'GET',
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'}
      });
      const accountInfo = await addressInfoResponse.json();

      this.accountInfo = accountInfo;
      this.setupCb(accountInfo ? null : `Account ${address} not found.`);
    }
  }

  getAddressFromPublicKey(hex) {
    const pubKey = this.EC.keyFromPublic(hex, 'hex');
    const hash = sha256ripemd160(ab2hexstring(pubKey.getPublic().encodeCompressed()));
    return encodeAddress(hash);
  }

  accountAddress(truncate=false) {
    const addr = this.accountInfo.value.address;
    if (!truncate || addr.lengh <= 32) {
      return addr;
    }
    return `${addr.substr(0, 15)}&hellip;${addr.substr(addr.length - 16)}`;
  }

  accountBalance(scale=true) {
    if (!this.accountInfo) {
      throw new Error('No address info. Do not call `balance`.');
    }
    const coin = _.find(this.accountInfo.value.coins, (coin) => coin.denom == App.config.remoteDenom);
    return parseFloat(coin.amount) / (scale ? App.config.remoteScaleFactor : 1);
  }

  async generateTransaction(txObject) {
    this.signError = null;
    const txPayload = await this.signTransaction(txObject);
    return txPayload;
  }

  async broadcastTransaction(txPayload) {
    if (!txPayload) {
      return false;
    }

    // console.log('FINAL TX', txPayload)
    const response = await fetch(App.config.broadcastTxPath, {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': $('meta[name=csrf-token]').attr('content')
      },
      body: JSON.stringify({payload: txPayload})
    });
    const responseData = await response.json();
    return responseData;
  }

  async signTransaction(tx) {
    const metadata = {
      sequence: this.accountInfo.value.sequence,
      account_number: this.accountInfo.value.account_number,
      chain_id: App.config.chainId
    };
    const preparedMessage = prepareMessage(tx, metadata);
    // console.log( "PREPARED", preparedMessage )

    const sigResponse = await this.device.sign(HD_PATH, preparedMessage);
    // console.log( 'SIGNED', sigResponse )

    let readyToSendTransaction = null;

    // console.log("LEDGER RETURN CODE", sigResponse.return_code)
    if (sigResponse.return_code == 36864) {
      const signature = createSignature(
          sigResponse.signature,
          this.accountInfo.value.sequence,
          this.accountInfo.value.account_number,
          this.pk,
          this.EC.curve
      );
      const signedTx = applySignature(tx, signature);
      readyToSendTransaction = signedTx;
    } else if (sigResponse.return_code == 27014) {
      this.signError = 'The transaction was rejected.';
    } else if (sigResponse.return_code == 28160) {
      this.signError = 'Ledger out of sync. Maybe it was power cycled?';
    } else {
      this.signError = `Unknown error. Code: ${sigResponse.return_code}`;
    }

    return readyToSendTransaction;
  }
}

function encodeAddress(value, prefix=null, type='hex') {
  if (prefix === null) {
    prefix = App.config.prefixes.account_address.replace(/1$/, '');
  }
  const words = bech32.toWords(bops.from(value, type));
  return bech32.encode(prefix, words);
}

function ab2hexstring(arr) {
  if (typeof arr !== 'object') {
    throw new Error('ab2hexstring expects an array');
  }
  let result = '';
  for (let i = 0; i < arr.length; i++) {
    let str = arr[i].toString(16);
    str = str.length === 0 ? '00' : str.length === 1 ? `0${str}` : str;
    result += str;
  }
  return result;
}

function sha256ripemd160(hex) {
  if (typeof hex !== 'string') {
    throw new Error('sha256ripemd160 expects a string');
  }
  if (hex.length % 2 !== 0) {
    throw new Error(`invalid hex string length: ${hex}`);
  }
  const hexEncoded = CryptoJS.enc.Hex.parse(hex);
  const ProgramSha256 = CryptoJS.SHA256(hexEncoded);
  return CryptoJS.RIPEMD160(ProgramSha256).toString();
}

function sortTransactionFields(tx) {
  if (_.isArray(tx)) {
    return _.map(tx, sortTransactionFields);
  }
  if (typeof(tx) != 'object') {
    return tx;
  }
  return _.reduce(_.keys(tx).sort(), (acc, key) => {
    if (tx[key] === undefined || tx[key] === null) {
      return acc;
    }
    acc[key] = sortTransactionFields(tx[key]);
    return acc;
  }, {});
}

function prepareMessage(tx, meta) {
  // for some reason we need to prepare the message for
  // signing with a `msgs` key, even though the actual transaction
  // needs a `msg` key... :shru
  const hackedTx = _.cloneDeep(tx);
  hackedTx.msgs = hackedTx.msg;
  delete hackedTx.msg;
  // end nonsense

  const preparedMsg = sortTransactionFields({...hackedTx, ...meta});
  return JSON.stringify(preparedMsg);
}

function applySignature(tx, signature) {
  const withSig = _.merge({}, tx, {signatures: [signature]});
  return withSig;
}

function createSignature(signature, sequence, accountNumber, publicKey, ecParams) {
  return {
    account_number: accountNumber,
    sequence,
    signature: signatureImport(signature, ecParams),
    pub_key: {
      type: 'tendermint/PubKeySecp256k1',
      value: publicKey.toString('base64')
    }
  };
}

function signatureImport(signature, ecParams) {
  let sigObj;
  try {
    sigObj = decodeBip66(signature);
    if (sigObj.r.length === 33 && sigObj.r[0] === 0x00) sigObj.r = sigObj.r.slice(1);
    if (sigObj.r.length > 32) throw new Error('R length is too long');
    if (sigObj.s.length === 33 && sigObj.s[0] === 0x00) sigObj.s = sigObj.s.slice(1);
    if (sigObj.s.length > 32) throw new Error('S length is too long');
  } catch (err) {
    console.error(err);
    return '';
  }

  // sigObj.r.copy(r, bops.create(32 - sigObj.r.length))
  // sigObj.s.copy(s, bops.create(32 - sigObj.s.length))

  let r = new BN(sigObj.r);
  if (r.cmp(ecParams.n) >= 0) {
    r = new BN(0);
  }

  let s = new BN(sigObj.s);
  if (s.cmp(ecParams.n) >= 0) {
    s = new BN(0);
  }

  return bops.to(bops.join([r.toArrayLike(Uint8Array, 'be', 32), s.toArrayLike(Uint8Array, 'be', 32)]), 'base64');
}

function decodeBip66(buffer) {
  if (buffer.length < 8) throw new Error('DER sequence length is too short');
  if (buffer.length > 72) throw new Error('DER sequence length is too long');
  if (buffer[0] !== 0x30) throw new Error('Expected DER sequence');
  if (buffer[1] !== buffer.length - 2) throw new Error('DER sequence length is invalid');
  if (buffer[2] !== 0x02) throw new Error('Expected DER integer');

  const lenR = buffer[3];
  if (lenR === 0) throw new Error('R length is zero');
  if (5 + lenR >= buffer.length) throw new Error('R length is too long');
  if (buffer[4 + lenR] !== 0x02) throw new Error('Expected DER integer (2)');

  const lenS = buffer[5 + lenR];
  if (lenS === 0) throw new Error('S length is zero');
  if ((6 + lenR + lenS) !== buffer.length) throw new Error('S length is invalid');

  if (buffer[4] & 0x80) throw new Error('R value is negative');
  if (lenR > 1 && (buffer[4] === 0x00) && !(buffer[5] & 0x80)) throw new Error('R value excessively padded');

  if (buffer[lenR + 6] & 0x80) throw new Error('S value is negative');
  if (lenS > 1 && (buffer[lenR + 6] === 0x00) && !(buffer[lenR + 7] & 0x80)) throw new Error('S value excessively padded');

  // non-BIP66 - extract R, S values
  return {
    r: buffer.slice(4, 4 + lenR),
    s: buffer.slice(6 + lenR)
  };
}

window.Ledger = Ledger;
