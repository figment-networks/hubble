class Livepeer::Queries::UnbondingsQuery < Livepeer::Queries::ReportQuery
  FIELDS = [
    'delegator_address',
    'SUM(livepeer_unbonds.amount) AS unbonding_tokens'
  ].freeze

  def call
    group_by_delegator(filter_by_range(filter_by_delegators(exclude_same_round_rebonds(chain.unbonds))))
  end

  private

  def exclude_same_round_rebonds(relation)
    relation.where("NOT EXISTS (#{<<~SQL})")
      SELECT 1
        FROM livepeer_rebonds
       WHERE delegator_address = livepeer_unbonds.delegator_address
             AND unbonding_lock_id = livepeer_unbonds.unbonding_lock_id
             AND round_id = livepeer_rounds.id
    SQL
  end
end
