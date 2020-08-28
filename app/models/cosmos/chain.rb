class Cosmos::Chain < ApplicationRecord
  include Cosmoslike::Chainlike

  SYNC_OFFSET = 1
  SYNC_INTERVAL = 1.minute
  SUPPORTS_LEDGER = true

  DEFAULT_TOKEN_DISPLAY = 'ATOM'
  DEFAULT_TOKEN_REMOTE = 'uatom'
  DEFAULT_TOKEN_FACTOR = 6

  PREFIXES = {
    account_address: 'cosmos1',
    account_public_key: 'cosmospub1',
    validator_consensus_address: 'cosmosvalcons1',
    validator_consensus_public_key: 'cosmosvalconspub1',
    validator_operator_address: 'cosmosvaloper1',
    validator_operator_public_key: 'cosmosvaloperpub1'
  }

  def network_name; 'Cosmos'; end
  def has_csir?; true; end
end
