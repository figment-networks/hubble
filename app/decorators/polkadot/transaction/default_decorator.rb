class Polkadot::Transaction::DefaultDecorator < SimpleDelegator
  def humanized_attributes(attributes = default_attributes)
    attributes.map do |attribute|
      if send(attribute).present?
        { name: display_name(attribute), value: send(attribute), type: attribute }
      end
    end.compact
  end

  def default_attributes
    %i[section method_name signature account]
  end

  def signature
    model.signature.truncate(50)
  end

  def humanized_method; end

  def parameters
    args.split(',')
  end

  def self.can_decorate?(_transaction)
    true
  end

  private

  def display_name(attribute)
    case attribute
    when :section
      'Module'
    when :method_name
      'Call'
    else
      attribute.to_s.humanize
    end
  end

  def model
    __getobj__
  end
end
