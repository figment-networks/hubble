const headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
};

export const getAccountDetails = async (endpoint, address) => {
  const accountResponse = await fetch(`${endpoint}/account_balances/${address}`, {
    method: 'GET',
    headers: headers
  });
  const responseJson = await accountResponse.json();

  if (responseJson.error) throw new Error(responseJson.error);

  return responseJson;
};

export const broadcastTransaction = async (
    endpoint,
    accountAddress,
    validator,
    fee,
    nonce,
    memo,
    signature) => {
  const broadcastResponse = await fetch(`${endpoint}/transaction_broadcasts`, {
    method: 'POST',
    credentials: 'same-origin',
    headers: headers,
    body: JSON.stringify({
      account_address: accountAddress,
      validator,
      fee,
      nonce,
      memo,
      signature
    })
  });

  const responseJson = await broadcastResponse.json();

  if (responseJson.error) throw new Error(responseJson.error);

  return responseJson.transaction_hash;
};
