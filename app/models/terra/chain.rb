class Terra::Chain < ApplicationRecord
  include Cosmoslike::Chainlike

  SYNC_OFFSET = 1
  SYNC_INTERVAL = 1.minute
  SUPPORTS_LEDGER = false

  PREFIXES = {
    account_address: 'terra1',
    account_public_key: 'terrapub1',
    validator_consensus_address: 'terravalcons1',
    validator_consensus_public_key: 'terravalconspub1',
    validator_operator_address: 'terravaloper1',
    validator_operator_public_key: 'terravaloperpub1'
  }

  DEFAULT_TOKEN_DISPLAY = 'LUNA'
  DEFAULT_TOKEN_REMOTE = 'uluna'
  DEFAULT_TOKEN_FACTOR = 6

  def network_name; 'Terra'; end
  def has_csir?; true; end
end
