module Common
  class Resource
    include ActiveModel::Model

    def initialize(attrs = {})
      mapping = self.class.mapping
      return super(attrs) unless mapping

      attrs = HashWithIndifferentAccess.new(attrs)

      mapping.each_pair do |name, opts|
        val = attrs[opts[:source]]
        val = opts[:default] if val.nil? && !opts[:default].nil?

        case opts[:type]
        when :integer
          instance_variable_set("@#{name}", val&.to_i)
        when :float
          instance_variable_set("@#{name}", val&.to_f)
        when :timestamp
          instance_variable_set("@#{name}", Time.zone.parse(val)) if val
        when :unix_timestamp
          instance_variable_set("@#{name}", Time.zone.at(val)) if val
        when Class
          if val
            val = opts[:collection] ? val.map { |v| opts[:type].new(v) } : opts[:type].new(val)
            instance_variable_set("@#{name}", val)
          end
        else
          instance_variable_set("@#{name}", val)
        end
      end
    end

    def method_missing(method_name, *arguments, &block)
      if instance_variable_defined?("@#{method_name}")
        instance_variable_get("@#{method_name}")
      else
        super
      end
    end

    def self.field(name, opts = {})
      @_fields ||= {}
      @_fields[name] = {
        type: opts[:type],
        source: opts.fetch(:source, name.to_s),
        collection: opts[:collection] == true,
        default: opts[:default]
      }
      __send__(:attr_accessor, name)
    end

    def self.collection(name, opts = {})
      field(name, opts.merge(collection: true, default: []))
    end

    def self.fields
      @_fields
    end

    def self.field_names
      @_fields.keys
    end

    def self.mapping
      @_mapping ||= ancestors.
        select { |ancestor| ancestor.respond_to?(:fields) }.
        flat_map(&:fields).
        compact.
        reverse.
        reduce(&:merge)
    end
  end
end
