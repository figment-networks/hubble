class Livepeer::Adapters::BaseAdapter
  def initialize(data)
    @data = Hashie::Mash::Rash.new(data)
  end

  def to_h
    Hash[self.class.attributes.map { |a| [a, send(a)] }]
  end

  def self.attributes
    @attributes || []
  end

  def self.attribute(name)
    name = name.to_sym

    @attributes ||= []
    @attributes << name unless @attributes.include?(name)
  end

  def self.has_many(resource, model_class = nil)
    attribute(resource)

    define_method(resource) do
      data[resource].map do |resource_data|
        adapter_class = Livepeer::Factories::AdapterFactory.new(resource).call
        model_class ||= Livepeer::Factories::ModelFactory.new(resource).call

        model_class.new(adapter_class.new(resource_data).to_h)
      end
    end
  end

  private

  attr_reader :data

  def method_missing(name, *)
    data[name]
  end

  def respond_to_missing?(*)
    true
  end

  def convert_percentage(value)
    value.to_d / 10_000 if value
  end

  def convert_lpt_amount(value)
    value.to_d / Livepeer::LPT_DENOMINATOR if value
  end

  def convert_eth_amount(value)
    value.to_d / Livepeer::ETH_DENOMINATOR if value
  end

  def convert_timestamp(value)
    DateTime.strptime(value, '%s') if value
  end
end
