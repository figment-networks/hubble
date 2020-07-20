class Livepeer::Queries::Graph::UnbondsQuery < Livepeer::Queries::Graph::BaseQuery
  private

  def build_query(batch_size, offset)
    round = round_data.id

    GQLi::DSL.query {
      unbonds(
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
        withdrawRound
        unbondingLockId
      }
    }
  end
end
