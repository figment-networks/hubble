class Livepeer::Queries::PoolStakesPerRoundQuery < Livepeer::Queries::PoolStakesQuery
  FIELDS = [
    'livepeer_rounds.number AS round_number',
    'orchestrator_address',
    'SUM(total_stake) AS total_stake'
  ].freeze

  def call
    chain.pools.
      then { |r| filter_by_range(r) }.
      then { |r| group_by_round_and_orchestrator(r) }
  end

  private

  def filter_by_date(relation)
    relation.where(<<~SQL, start_date, end_date)
      date(livepeer_rounds.initialized_at) BETWEEN ? AND ?
    SQL
  end
end
