module NearTransactionActionHelper
  def action_response(action, receiver)
    case action['type']
    when 'FunctionCall'
      "Called <i>\'#{action['data']['method_name']}\'</i> on contract: #{receiver}"
    when 'AddKey'
      "New key added for <i>\'#{@transaction.receiver}\'</i>:#{action['data']['public_key'].truncate(10)}... with #{action['data']['access_key']['permission']} and nonce #{action['data']['access_key']['nonce']}"
    when 'CreateAccount'
      'Created a new Account'
    when 'DeployContract'
      'Deployed Contract'
    when 'Transfer'
      "Transferred #{format_amount(action['data']['deposit'].to_i, denom: 'near')} to #{receiver}"
    when 'Stake'
      'Expressed interest in becoming a proof-of-stake validator'
    when 'DeleteKey'
      'Removed Public Key'
    when 'DeleteAccount'
      "Deleted Account and transferred funds to #{action['data']['beneficiary_id']}"
    end
  end
end
