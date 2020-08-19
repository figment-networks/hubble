class Livepeer::Queries::UnbondingsPerRoundQuery < Livepeer::Queries::UnbondingsQuery
  FIELDS = [
    'livepeer_rounds.number AS round_number',
    'delegator_address',
    'SUM(livepeer_unbonds.amount) AS unbonding_tokens'
  ].freeze

  def call
    group_by_round_and_delegator(filter_by_range(filter_by_delegators(exclude_same_round_rebonds(chain.unbonds))))
  end
end
