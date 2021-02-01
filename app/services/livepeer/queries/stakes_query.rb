class Livepeer::Queries::StakesQuery < Livepeer::Queries::ReportQuery
  FIELDS = [
    'delegator_address',
    'SUM(pending_stake) AS pending_stake',
    'SUM(unclaimed_stake) AS unclaimed_stake'
  ].freeze

  def call
    chain.stakes.
      then { |r| filter_by_delegators(r) }.
      then { |r| filter_by_range(r) }.
      then { |r| group_by_delegator(r) }
  end

  def filter_by_date(relation)
    relation.where(<<~SQL, end_date: end_date)
      livepeer_rounds.number = (
          SELECT number
            FROM livepeer_rounds
           WHERE date(initialized_at) <= :end_date
                 AND chain_id = #{chain.id}
        ORDER BY number DESC
           LIMIT 1
      )
    SQL
  end
end
