class Livepeer::Queries::Graph::DelegatorsQuery < Livepeer::Queries::Graph::BaseQuery
  private

  def build_query(batch_size, offset)
    GQLi::DSL.query {
      delegators(
        where: { delegate_not: :null },
        first: batch_size,
        skip: offset
      ) {
        id
        delegate { id }
        pendingStake
      }
    }
  end
end
