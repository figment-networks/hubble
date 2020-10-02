class Livepeer::RoundSyncService < Livepeer::BaseSyncService
  ID_COLUMN = :number
  ID_ATTRIBUTE = :id

  private

  def data
    @_data ||= @data.merge(
      stakes: fetch_objects(:stakes),
      bonds: fetch_objects(:bonds),
      unbonds: fetch_objects(:unbonds),
      rebonds: fetch_objects(:rebonds),
      reward_cut_changes: fetch_objects(:reward_cut_changes),
      missed_reward_calls: fetch_objects(:missed_reward_calls),
      deactivations: fetch_objects(:deactivations),
      slashings: fetch_objects(:slashings)
    )
  end

  def fetch_objects(resource)
    query_class = Livepeer::Factories::GraphQueryFactory.new(resource).call
    query_class.new(chain, @data).call
  end
end
