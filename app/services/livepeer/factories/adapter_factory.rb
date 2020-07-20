class Livepeer::Factories::AdapterFactory
  def initialize(resource)
    @resource = resource.to_s
  end

  def call
    Livepeer::Adapters.const_get(class_name)
  end

  private

  attr_reader :resource

  def class_name
    "#{resource.classify}Adapter"
  end
end
