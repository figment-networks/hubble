class Livepeer::DeleteRemainingRecordsService
  def initialize(chain, resource, objects)
    @chain = chain
    @resource = resource
    @objects = objects
  end

  def call
    records_ids = objects.map { |o| o[id_attribute] }
    chain.send(resource).where.not(id_column => records_ids).delete_all
  end

  private

  attr_reader :chain
  attr_reader :resource
  attr_reader :objects

  def id_attribute
    sync_service_class::ID_ATTRIBUTE
  end

  def id_column
    sync_service_class::ID_COLUMN
  end

  def sync_service_class
    @sync_service_class ||= Livepeer::Factories::SyncServiceFactory.new(resource).call
  end
end
