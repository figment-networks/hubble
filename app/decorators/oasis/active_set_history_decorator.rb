class Oasis::ActiveSetHistoryDecorator
  def initialize( validator )
    @validator = validator
  end

  def as_json
    data = @validator.active_set_history.reverse.map do |ash|
      { t: ash.timestamp.iso8601, inout: ash.positive? ? 'in' : 'out' }
    end

    data << { t: Time.now.utc.iso8601, inout: @validator.in_active_set? ? 'in' : 'out' }

    first = data.first
    data.unshift( t: Time.parse( first[:t] ).utc.beginning_of_day.iso8601, inout: 'in' )

    data
  end
end
