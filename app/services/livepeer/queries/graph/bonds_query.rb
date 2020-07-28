class Livepeer::Queries::Graph::BondsQuery < Livepeer::Queries::Graph::BaseQuery
  private

  def build_query(batch_size, offset)
    round = round_data.id

    GQLi::DSL.query {
      bonds(
        where: { round: round },
        orderBy: 'timestamp',
        first: batch_size,
        skip: offset
      ) {
        __node('transactionHash: hash')
        delegator { id }
        newDelegate { id }
        oldDelegate { id }
        additionalAmount
        timestamp
      }
    }
  end
end
