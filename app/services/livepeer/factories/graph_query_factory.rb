class Livepeer::Factories::GraphQueryFactory
  def initialize(resource)
    @resource = resource.to_s
  end

  def call
    Livepeer::Queries::Graph.const_get(class_name)
  end

  private

  attr_reader :resource

  def class_name
    "#{resource.capitalize}Query"
  end
end
