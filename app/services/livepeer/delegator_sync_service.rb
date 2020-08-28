class Livepeer::DelegatorSyncService < Livepeer::BaseSyncService
  STRATEGY = Livepeer::Strategies::UpdateExistingStrategy

  ID_COLUMN = :address
  ID_ATTRIBUTE = :id
end
