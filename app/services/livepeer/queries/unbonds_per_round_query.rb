class Livepeer::Queries::UnbondsPerRoundQuery < Livepeer::Queries::UnbondsQuery
  FIELDS = [
    'withdraw_rounds.number AS round_number',
    'delegator_address',
    'SUM(livepeer_unbonds.amount) AS unbonded_tokens'
  ].freeze

  def call
    group_by_round_and_delegator(filter_by_range(filter_by_delegators(exclude_rebonds(unbonds))))
  end
end
