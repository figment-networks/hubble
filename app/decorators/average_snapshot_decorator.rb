class AverageSnapshotDecorator
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
    q = @chain.average_snapshots.
      where({ kind: @kind, interval: @interval, scopeable: @scope }.compact)

    if with_days_as_hours > 0
      q = q.where('timestamp < ?', with_days_as_hours.days.ago)
    end

    if @datapoints
      q = q.limit(@datapoints)
    end

    data = q.reverse_each.map do |snapshot|
      { t: snapshot.timestamp.iso8601, y: snapshot.average.to_f }
    end

    if with_todays_average
      today = Time.now.utc
      q = @chain.average_snapshots.
        where({ kind: @kind, interval: 'hour', scopeable: @scope }.compact).
        where('timestamp >= ? AND timestamp <= ?', today.beginning_of_day, today.end_of_day).
        to_a

      if q.any?
        total = 0
        count = 0
        q.each do |snapshot|
          total += snapshot.sum
          count += snapshot.count
        end
        data << { t: today.beginning_of_day.iso8601, y: count == 0 ? 0 : (total / count) }
      end
    end

    if with_days_as_hours > 0
      q = @chain.average_snapshots.
        where({ kind: @kind, interval: 'hour', scopeable: @scope }.compact).
        where('timestamp >= ?', with_days_as_hours.days.ago).
        to_a
      q.reverse_each do |snapshot|
        data << { t: snapshot.timestamp.iso8601, y: snapshot.average.to_f }
      end
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
