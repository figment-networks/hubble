class Livepeer::Queries::Graph::LatestRoundQuery < Livepeer::Queries::Graph::BaseQuery
  def call
    super[0]
  end

  private

  def resource
    :rounds
  end

  def resource_name
    'latest round'
  end

  def build_query(_batch_size, _offset)
    GQLi::DSL.query {
      rounds(
        where: { initialized: true },
        orderBy: 'timestamp',
        orderDirection: 'desc',
        first: 1,
      ) {
        id
      }
    }
  end
end
