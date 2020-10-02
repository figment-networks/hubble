class Livepeer::Queries::Graph::OrchestratorsQuery < Livepeer::Queries::Graph::BaseQuery
  private

  def build_query(batch_size, offset)
    GQLi::DSL.query {
      __node(
        'orchestrators: transcoders',
        first: batch_size,
        skip: offset
      ) {
        id
        active
        rewardCut
        feeShare
        totalStake
      }
    }
  end
end
