class Livepeer::Queries::Graph::RewardCutChangesQuery < Livepeer::Queries::Graph::BaseQuery
  private

  def build_query(batch_size, offset)
    round = round_data.id

    GQLi::DSL.query {
      __node(
        'rewardCutChanges: transcoderUpdateds',
        where: { round: round },
        orderBy: 'timestamp',
        first: batch_size,
        skip: offset
      ) {
        __node('transactionHash: hash')
        delegate { id }
        rewardCut
        timestamp
      }
    }
  end
end
