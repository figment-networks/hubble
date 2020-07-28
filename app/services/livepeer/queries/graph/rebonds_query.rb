class Livepeer::Queries::Graph::RebondsQuery < Livepeer::Queries::Graph::BaseQuery
  private

  def build_query(batch_size, offset)
    round = round_data.id

    GQLi::DSL.query {
      rebonds(
        where: { round: round },
        orderBy: 'timestamp',
        first: batch_size,
        skip: offset
      ) {
        __node('transactionHash: hash')
        delegator { id }
        delegate { id }
        amount
        timestamp
        unbondingLockId
      }
    }
  end
end
