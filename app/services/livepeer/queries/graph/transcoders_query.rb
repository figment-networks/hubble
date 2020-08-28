class Livepeer::Queries::Graph::TranscodersQuery < Livepeer::Queries::Graph::BaseQuery
  private

  def build_query(batch_size, offset)
    GQLi::DSL.query {
      transcoders(
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
