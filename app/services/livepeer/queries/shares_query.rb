class Livepeer::Queries::SharesQuery < Livepeer::Queries::ReportQuery
  FIELDS = [
    'delegator_address',
    'SUM(livepeer_shares.fees) AS fees',
    'SUM(livepeer_shares.reward_tokens) AS reward_tokens'
  ].freeze

  def call
    group_by_delegator(filter_by_range(filter_by_delegators(shares)))
  end

  private

  def shares
    chain.shares.joins(pool: :round)
  end

  def filter_by_round(relation)
    relation.where(pools: { livepeer_rounds: { number: round_number } })
  end

  def filter_by_date(relation)
    relation.where(pools: { livepeer_rounds: { initialized_at: date_range } })
  end
end
