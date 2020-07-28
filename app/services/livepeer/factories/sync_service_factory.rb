class Livepeer::Factories::SyncServiceFactory
  def initialize(resource)
    @resource = resource.to_s
  end

  def call
    Livepeer.const_get(class_name)
  end

  private

  attr_reader :resource

  def class_name
    "#{resource.classify}SyncService"
  end
end
