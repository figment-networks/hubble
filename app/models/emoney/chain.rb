class Emoney::Chain < ApplicationRecord
  include Cosmoslike::Chainlike

  SYNC_OFFSET = 1
  SYNC_INTERVAL = 1.minute
  SUPPORTS_LEDGER = true

  PREFIXES = {
    account_address: 'emoney1',
    account_public_key: 'emoneypub1',
    validator_consensus_address: 'emoneyvalcons1',
    validator_consensus_public_key: 'emoneyvalconspub1',
    validator_operator_address: 'emoneyvaloper1',
    validator_operator_public_key: 'emoneyvaloperpub1'
  }

  DEFAULT_TOKEN_DISPLAY = 'NGM'
  DEFAULT_TOKEN_REMOTE = 'ungm'
  DEFAULT_TOKEN_FACTOR = 6

  def network_name; 'e-Money'; end
end
