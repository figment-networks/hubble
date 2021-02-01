class Livepeer::Queries::StakesPerRoundQuery < Livepeer::Queries::StakesQuery
  FIELDS = [
    'livepeer_rounds.number AS round_number',
    'delegator_address',
    'SUM(pending_stake) AS pending_stake',
    'SUM(unclaimed_stake) AS unclaimed_stake'
  ].freeze

  def call
    chain.stakes.
      then { |r| filter_by_delegators(r) }.
      then { |r| filter_by_range(r) }.
      then { |r| group_by_round_and_delegator(r) }
  end

  private

  def filter_by_date(relation)
    relation.where(<<~SQL, start_date, end_date)
      date(livepeer_rounds.initialized_at) BETWEEN ? AND ?
    SQL
  end
end
