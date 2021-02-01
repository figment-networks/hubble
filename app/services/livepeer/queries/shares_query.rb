class Livepeer::Queries::SharesQuery < Livepeer::Queries::ReportQuery
  FIELDS = [
    'delegator_address',
    'SUM(livepeer_shares.fees) AS fees',
    'SUM(livepeer_shares.reward_tokens) AS reward_tokens'
  ].freeze

  def call
    chain.shares.
      then { |r| filter_by_delegators(r) }.
      then { |r| filter_by_range(r) }.
      then { |r| group_by_delegator(r) }
  end
end
