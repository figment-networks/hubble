class Oasis::AverageSnapshotDecorator
  include FormattingHelper

  def initialize(chain, kind, interval, datapoints = nil, scope = nil)
    @chain = chain
    @interval = interval
    @kind = kind
    @scope = scope
    @datapoints = datapoints
  end

  def as_json(with_todays_average: false, with_days_as_hours: 0, override_current_time_value: nil)
    # Rails.logger.debug "Retreiving #{@datapoints||'all'} datapoints for #{@kind}/#{@interval} for #{@scope.inspect}"
    q = @chain.oasis_average_snapshots(@kind, @interval, @datapoints, @scope)
    q = q.sort_by(&:time_bucket)

    data = q.each.map do |snapshot|
      case @kind
      when 'block-time'
        avg = snapshot.block_time_avg.to_f
      when 'voting-power'
        avg = snapshot.voting_power_avg.to_f
      when 'validator-uptime'
        avg = snapshot.uptime_avg.to_f
      end
      { t: DateTime.parse(snapshot.time_bucket), y: avg }
    end

    # duplicate the last value to right now
    if data.any?
      last_item = data.last.merge t: Time.now.utc.iso8601
      if override_current_time_value
        last_item[:y] = (override_current_time_value / 100.0).to_f
      end
      data << last_item
    end
    data
  end
end
