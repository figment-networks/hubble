class Livepeer::BaseSyncService
  STRATEGY = Livepeer::Strategies::IgnoreExistingStrategy

  def initialize(chain, data)
    @chain = chain
    @data = Hashie::Mash::Rash.new(data)
  end

  def call
    self.class::STRATEGY.new(relation, attributes).call
  end

  private

  attr_reader :chain
  attr_reader :data

  def relation
    chain.send(resource).where(self.class::ID_COLUMN => data[self.class::ID_ATTRIBUTE])
  end

  def attributes
    adapter_class = Livepeer::Factories::AdapterFactory.new(resource).call
    adapter_class.new(data).to_h
  end

  def resource
    @resource ||= self.class.name.demodulize.underscore.split('_')[0].pluralize
  end
end
