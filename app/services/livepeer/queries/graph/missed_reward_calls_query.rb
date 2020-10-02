class Livepeer::Queries::Graph::MissedRewardCallsQuery < Livepeer::Queries::Graph::BaseQuery
  private

  def build_query(batch_size, offset)
    round = round_data.id

    GQLi::DSL.query {
      __node(
        'missedRewardCalls: pools',
        where: {
          round: round,
          rewardTokens: :null
        },
        orderBy: 'id',
        first: batch_size,
        skip: offset
      ) {
        delegate { id }
        round { timestamp }
      }
    }
  end
end
