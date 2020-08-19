class Livepeer::Factories::ModelFactory
  def initialize(resource)
    @resource = resource.to_s
  end

  def call
    class_name.constantize
  end

  private

  attr_reader :resource

  def class_name
    "Livepeer::#{resource.classify}"
  end
end
