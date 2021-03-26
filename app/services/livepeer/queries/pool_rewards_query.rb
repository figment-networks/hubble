class Livepeer::Queries::PoolRewardsQuery < Livepeer::Queries::PoolReportQuery
  FIELDS = [
    'orchestrator_address',
    'SUM(reward_tokens) AS reward_tokens'
  ].freeze

  def call
    chain.pools.
      then { |r| filter_by_range(r) }.
      then { |r| group_by_orchestrator(r) }
  end
end
