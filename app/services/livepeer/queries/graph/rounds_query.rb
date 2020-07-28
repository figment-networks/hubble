class Livepeer::Queries::Graph::RoundsQuery < Livepeer::Queries::Graph::BaseQuery
  LIMIT = 10
  ROUND_LENGTH = 5760

  def call
    fetch_latest_round
    super
  end

  private

  attr_reader :latest_round

  def fetch_latest_round
    @latest_round = Livepeer::Queries::Graph::LatestRoundQuery.new(chain).call
  end

  def build_query(batch_size, offset)
    min_start_block = chain.latest_local_height * ROUND_LENGTH
    max_start_block = latest_round.id.to_i * ROUND_LENGTH

    GQLi::DSL.query {
      rounds(
        where: {
          initialized: true,
          startBlock_gt: min_start_block,
          startBlock_lt: max_start_block
        },
        orderBy: 'timestamp',
        first: batch_size,
        skip: offset
      ) {
        id
        timestamp
        startBlock
        mintableTokens
        pools {
          delegate { id }
          totalStake
          fees
          rewardTokens
          shares {
            delegator { id }
            fees
            rewardTokens
          }
        }
      }
    }
  end
end
