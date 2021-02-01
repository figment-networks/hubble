class Livepeer::Queries::UnbondingsQuery < Livepeer::Queries::ReportQuery
  FIELDS = [
    'delegator_address',
    'SUM(livepeer_unbonds.amount) AS unbonding_tokens'
  ].freeze

  def call
    chain.unbonds.
      then { |r| exclude_same_round_rebonds(r) }.
      then { |r| filter_by_delegators(r) }.
      then { |r| filter_by_range(r) }.
      then { |r| group_by_delegator(r) }
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
