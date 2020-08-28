class Livepeer::Queries::Graph::StakesQuery < Livepeer::Queries::Graph::BaseQuery
  private

  def build_query(batch_size, offset)
    block_number = round_data.start_block.to_i

    GQLi::DSL.query {
      __node(
        'stakes: delegators',
        where: { pendingStake_gt: 0 },
        block: { number: block_number },
        first: batch_size,
        skip: offset
      ) {
        id
        pendingStake
        bondedAmount
      }
    }
  end
end
