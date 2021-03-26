class Livepeer::Queries::PoolStakesQuery < Livepeer::Queries::PoolReportQuery
  FIELDS = [
    'orchestrator_address',
    'SUM(total_stake) AS total_stake'
  ].freeze

  def call
    chain.pools.
      then { |r| filter_by_range(r) }.
      then { |r| group_by_orchestrator(r) }
  end

  private

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
