module Common
  class Resource
    include ActiveModel::Model

    def initialize(attrs = {})
      fields = self.class.fields
      return super(attrs) unless fields

      self.class.fields.each_pair do |name, opts|
        key = name.to_s
        val = attrs[key]
        val = opts[:default] if val.nil? && !opts[:default].nil?

        case opts[:type]
        when :integer
          instance_variable_set("@#{name}", val&.to_i)
        when :float
          instance_variable_set("@#{name}", val&.to_f)
        when :timestamp
          if val
            instance_variable_set("@#{name}", Time.zone.parse(val))
          end
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

    def self.field(name, opts = {})
      @_fields ||= {}
      @_fields[name] = {
        type: opts[:type],
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
  end
end
