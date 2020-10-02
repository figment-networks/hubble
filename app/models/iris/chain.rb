class Iris::Chain < ApplicationRecord
  include Cosmoslike::Chainlike

  SYNC_OFFSET = 1
  SYNC_INTERVAL = 1.minute
  SUPPORTS_LEDGER = false

  DEFAULT_TOKEN_DISPLAY = 'IRIS'.freeze
  DEFAULT_TOKEN_REMOTE = 'iris-atto'.freeze
  DEFAULT_TOKEN_FACTOR = 18

  PREFIXES = {
    account_address: 'iaa1',
    account_public_key: 'iap1',
    validator_consensus_address: 'ica1',
    validator_consensus_public_key: 'icp1',
    validator_operator_address: 'iva1',
    validator_operator_public_key: 'ivp1'
  }.freeze
  TESTNET_PREFIXES = {
    account_address: 'faa1',
    account_public_key: 'fap1',
    validator_consensus_address: 'fca1',
    validator_consensus_public_key: 'fcp1',
    validator_operator_address: 'fva1',
    validator_operator_public_key: 'fvp1'
  }.freeze

  def network_name
    'IRIS'
  end

  def prefixes
    testnet? ? TESTNET_PREFIXES : PREFIXES
  end
end
