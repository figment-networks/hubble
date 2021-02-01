class Livepeer::Queries::SharesPerRoundQuery < Livepeer::Queries::SharesQuery
  FIELDS = [
    'livepeer_rounds.number AS round_number',
    'delegator_address',
    'SUM(livepeer_shares.fees) AS fees',
    'SUM(livepeer_shares.reward_tokens) AS reward_tokens'
  ].freeze

  def call
    chain.shares.
      then { |r| filter_by_delegators(r) }.
      then { |r| filter_by_range(r) }.
      then { |r| group_by_round_and_delegator(r) }
  end
end
