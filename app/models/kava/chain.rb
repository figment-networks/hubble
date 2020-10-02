class Kava::Chain < ApplicationRecord
  include Cosmoslike::Chainlike

  SYNC_OFFSET = 1
  SYNC_INTERVAL = 1.minute
  SUPPORTS_LEDGER = false

  DEFAULT_TOKEN_DISPLAY = 'KAVA'.freeze
  DEFAULT_TOKEN_REMOTE = 'ukava'.freeze
  DEFAULT_TOKEN_FACTOR = 6

  PREFIXES = {
    account_address: 'kava1',
    account_public_key: 'kavapub1',
    validator_consensus_address: 'kavavalcons1',
    validator_consensus_public_key: 'kavavalconspub1',
    validator_operator_address: 'kavavaloper1',
    validator_operator_public_key: 'kavavaloperpub1'
  }.freeze

  def network_name
    'Kava'
  end

  def has_csir?
    true
  end
end
