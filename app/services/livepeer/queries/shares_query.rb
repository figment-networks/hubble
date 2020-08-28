class Livepeer::Queries::SharesQuery < Livepeer::Queries::ReportQuery
  FIELDS = [
    'delegator_address',
    'SUM(livepeer_shares.fees) AS fees',
    'SUM(livepeer_shares.reward_tokens) AS reward_tokens'
  ].freeze

  def call
    group_by_delegator(filter_by_range(filter_by_delegators(chain.shares)))
  end
end
