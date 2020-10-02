class Livepeer::Queries::Graph::DeactivationsQuery < Livepeer::Queries::Graph::BaseQuery
  private

  def build_query(batch_size, offset)
    round = previous_round.to_s

    GQLi::DSL.query {
      __node(
        'deactivations: transcoderDeactivateds',
        where: { round: round },
        orderBy: 'timestamp',
        first: batch_size,
        skip: offset
      ) {
        __node('transactionHash: hash')
        delegate { id }
        timestamp
      }
    }
  end

  def previous_round
    round_data.id.to_i - 1
  end
end
