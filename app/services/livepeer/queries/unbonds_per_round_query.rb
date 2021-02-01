class Livepeer::Queries::UnbondsPerRoundQuery < Livepeer::Queries::UnbondsQuery
  FIELDS = [
    'withdraw_rounds.number AS round_number',
    'delegator_address',
    'SUM(livepeer_unbonds.amount) AS unbonded_tokens'
  ].freeze

  def call
    unbonds.
      then { |r| exclude_rebonds(r) }.
      then { |r| filter_by_delegators(r) }.
      then { |r| filter_by_range(r) }.
      then { |r| group_by_round_and_delegator(r) }
  end
end
