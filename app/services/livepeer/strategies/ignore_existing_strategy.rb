class Livepeer::Strategies::IgnoreExistingStrategy
  def initialize(relation, attributes)
    @relation = relation
    @attributes = attributes
  end

  def call
    relation.first_or_create!(attributes)
  end

  private

  attr_reader :relation
  attr_reader :attributes
end
