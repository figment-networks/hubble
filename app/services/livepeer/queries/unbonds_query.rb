class Livepeer::Queries::UnbondsQuery < Livepeer::Queries::ReportQuery
  FIELDS = [
    'delegator_address',
    'SUM(livepeer_unbonds.amount) AS unbonded_tokens'
  ].freeze

  def call
    group_by_delegator(filter_by_range(filter_by_delegators(exclude_rebonds(unbonds))))
  end

  private

  def unbonds
    chain.unbonds.joins(<<~SQL)
      JOIN livepeer_rounds AS withdraw_rounds
        ON withdraw_rounds.number = livepeer_unbonds.withdraw_round_number
           AND withdraw_rounds.chain_id = livepeer_rounds.chain_id
    SQL
  end

  def exclude_rebonds(relation)
    relation.where("NOT EXISTS (#{<<~SQL})")
      SELECT 1
        FROM livepeer_rebonds
        JOIN livepeer_rounds AS rebond_rounds
          ON rebond_rounds.id = livepeer_rebonds.round_id
       WHERE delegator_address = livepeer_unbonds.delegator_address
             AND unbonding_lock_id = livepeer_unbonds.unbonding_lock_id
             AND rebond_rounds.chain_id = withdraw_rounds.chain_id
    SQL
  end

  def filter_by_round(relation)
    relation.where(withdraw_rounds: { number: round_number })
  end

  def filter_by_date(relation)
    relation.where(withdraw_rounds: { initialized_at: date_range })
  end
end
