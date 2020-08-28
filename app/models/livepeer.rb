module Livepeer
  UNBONDING_PERIOD = 7

  LPT_DENOMINATOR = 1_000_000_000_000_000_000
  ETH_DENOMINATOR = 1_000_000_000_000_000_000

  def self.table_name_prefix
    'livepeer_'
  end
end
