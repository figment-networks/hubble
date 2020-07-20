class Emoney::SyncBase < Cosmoslike::SyncBase
  def get_community_pool
    nil # emoney doesn't use community pool, says andy
  end
end
