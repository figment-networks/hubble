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
      reward_cut_changes: fetch_objects(:reward_cut_changes)
    )
  end

  def fetch_objects(resource)
    query_class = Livepeer::Factories::GraphQueryFactory.new(resource).call
    query_class.new(chain, @data).call
  end
end
