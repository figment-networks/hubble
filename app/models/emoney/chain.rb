class Emoney::Chain < ApplicationRecord
  include Cosmoslike::Chainlike

  SYNC_OFFSET = 1
  SYNC_INTERVAL = 1.minute
  SUPPORTS_LEDGER = false

  DEFAULT_TOKEN_DISPLAY = 'NGM'.freeze
  DEFAULT_TOKEN_REMOTE = 'ungm'.freeze
  DEFAULT_TOKEN_FACTOR = 6

  # total supply is fixed on E-money, thus so is inflation
  TOTAL_SUPPLY = 100_000_000_000_000
  INFLATION = 0

  PREFIXES = {
    account_address: 'emoney1',
    account_public_key: 'emoneypub1',
    validator_consensus_address: 'emoneyvalcons1',
    validator_consensus_public_key: 'emoneyvalconspub1',
    validator_operator_address: 'emoneyvaloper1',
    validator_operator_public_key: 'emoneyvaloperpub1'
  }.freeze

  def network_name
    'e-Money'
  end

  def total_supply
    TOTAL_SUPPLY
  end

  def inflation
    INFLATION
  end
end
