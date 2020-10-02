class Livepeer::OrchestratorSyncService < Livepeer::BaseSyncService
  STRATEGY = Livepeer::Strategies::UpdateExistingStrategy

  ID_COLUMN = :address
  ID_ATTRIBUTE = :id

  private

  def data
    @_data ||= @data.merge(profile: fetch_profile)
  end

  def fetch_profile
    ThreeboxClient.new(@data.id).fetch_space(:livepeer)
  end
end
