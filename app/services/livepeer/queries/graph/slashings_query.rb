class Livepeer::Queries::Graph::SlashingsQuery < Livepeer::Queries::Graph::BaseQuery
  private

  def build_query(batch_size, offset)
    round = round_data.id

    GQLi::DSL.query {
      __node(
        'slashings: transcoderSlasheds',
        where: { round: round },
        orderBy: 'timestamp',
        first: batch_size,
        skip: offset
      ) {
        __node('transactionHash: hash')
        delegate { id }
        penalty
        timestamp
      }
    }
  end
end
