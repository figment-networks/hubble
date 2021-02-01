class Livepeer::Queries::UnbondingsPerRoundQuery < Livepeer::Queries::UnbondingsQuery
  FIELDS = [
    'livepeer_rounds.number AS round_number',
    'delegator_address',
    'SUM(livepeer_unbonds.amount) AS unbonding_tokens'
  ].freeze

  def call
    chain.unbonds.
      then { |r| exclude_same_round_rebonds(r) }.
      then { |r| filter_by_delegators(r) }.
      then { |r| filter_by_range(r) }.
      then { |r| group_by_round_and_delegator(r) }
  end
end
