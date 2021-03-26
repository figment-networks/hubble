class Livepeer::Queries::PoolRewardsPerRoundQuery < Livepeer::Queries::PoolRewardsQuery
  FIELDS = [
    'livepeer_rounds.number AS round_number',
    'orchestrator_address',
    'SUM(reward_tokens) AS reward_tokens'
  ].freeze

  def call
    chain.pools.
      then { |r| filter_by_range(r) }.
      then { |r| group_by_round_and_orchestrator(r) }
  end
end
