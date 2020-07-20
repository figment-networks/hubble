class Livepeer::Factories::ModelFactory
  def initialize(resource)
    @resource = resource.to_s
  end

  def call
    Livepeer.const_get(class_name)
  end

  private

  attr_reader :resource

  def class_name
    resource.classify
  end
end
