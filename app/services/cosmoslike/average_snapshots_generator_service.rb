class Cosmoslike::AverageSnapshotsGeneratorService
  BATCH_SIZE = 200

  def initialize( chain )
    @chain = chain
  end

  def generate_voting_power_snapshots!
    ProgressReport.instance.start "Updating validator voting power snapshots for #{@chain.name}..."
    hourly_average_snapshots!( 'voting-power' ) do |block|
      block.validator_set.values.compact.sum
    end
    daily_average_snapshots!( 'voting-power' )
    clean_old_hourly_average_snapshots!( 'voting-power', keep: 72.hours )
    ProgressReport.instance.report
  end

  def generate_validator_uptime_snapshots!
    ProgressReport.instance.start "Updating average uptime snapshots for #{@chain.name}..."
    validators = @chain.validators
    validators.each_with_index do |validator, i|
      puts "Validator: #{validator.address} (#{i+1}/#{validators.count})" if ENV['DEBUG']
      hourly_average_snapshots!( 'validator-uptime', validator ) do |block|
        block.precommitters.include?(validator.address) ? 1.0 : 0.0
      end
      daily_average_snapshots!( 'validator-uptime', validator )
      clean_old_hourly_average_snapshots!( 'validator-uptime', validator, keep: 72.hours )
    end
    ProgressReport.instance.report
  end

  def generate_active_validators_snapshots!
    ProgressReport.instance.start "Updating average active validators snapshots for #{@chain.name}..."
    hourly_average_snapshots!( 'active-validators' ) do |block|
      block.validator_set.keys.count
    end
    # daily_average_snapshots!( 'active-validators' )
    clean_old_hourly_average_snapshots!( 'active-validators', keep: 72.hours )
    ProgressReport.instance.report
  end

  def generate_block_time_snapshots!
    ProgressReport.instance.start "Updating average block time snapshots for #{@chain.name}..."
    last_time_seen = nil
    hourly_average_snapshots!( 'block-time' ) do |block, latest|
      timestamp = block.try(:timestamp) || latest
      value = last_time_seen ? (timestamp - last_time_seen) : nil
      last_time_seen = timestamp
      value
    end
    # daily_average_snapshots!( 'block-time' )
    clean_old_hourly_average_snapshots!( 'block-time', keep: 72.hours )
    ProgressReport.instance.report
  end

  protected

  def clean_old_hourly_average_snapshots!( kind, object_scope=nil, keep: 48.hours )
    print "Cleaning old hourly averages for #{kind}#{" (#{object_scope.class}/#{object_scope.id})" if object_scope}... "
    if @chain.blocks.any?
      snapshots = @chain.average_snapshots
        .where( { kind: kind, scopeable: object_scope, interval: 'hour' }.compact )
        .where( 'timestamp < ?', @chain.blocks.first.timestamp - keep )
      count = snapshots.count
      snapshots.delete_all
    else
      count = 0
    end
    puts "DONE (#{count} purged)"
  end

  def hourly_average_snapshots!( kind, object_scope=nil, &value_generator )
    # first find the latest snapshot
    latest = @chain.average_snapshots.where( { kind: kind, scopeable: object_scope, interval: 'hour' }.compact ).first.try(:timestamp)

    if !latest
      # no snapshots yet, we can use the start of the chain
      latest = object_scope && object_scope.respond_to?(:first_seen_at) ?
        adjust_for_interval('hour', object_scope.first_seen_at, :beginning) :
        adjust_for_interval('hour', @chain.blocks.last.try(:timestamp), :beginning)
    else
      # we push 1 more {interval} since we already have the snapshot for 'latest'
      latest = adjust_for_interval('hour', latest + 1.hour, :beginning)
    end

    if !latest
      puts "No blocks." if ENV['DEBUG']
      return
    end

    start_time = latest.to_f

    # now just keep going through the {interval}s until we reach the last time period
    # or the time period which includes the last block, but go back one
    target = [ 1.hour.ago, @chain.blocks.first.try(:timestamp).try(:-, 1.hour) ].compact.min
    target = adjust_for_interval( 'hour', target, :beginning )
    while latest <= target
      date_start_time = Time.now.utc.to_f

      print "Generating hourly average #{kind}#{" (#{object_scope.class}/#{object_scope.id})" if object_scope} snapshot for #{latest}... " if ENV['DEBUG']

      blocks = @chain.blocks.reorder('height ASC').where(
        %{ timestamp >= ? AND timestamp <= ? },
        adjust_for_interval('hour', latest, :beginning),
        adjust_for_interval('hour', latest, :end)
      )
      # blocks.each { |b| puts "\t#{b.timestamp}, #{b.height}" }

      values = []

      total_blocks = blocks.count
      current_offset = 0
      current_block_set = nil

      while current_block_set.nil? || current_block_set.any?
        batch_start_time = Time.now.utc.to_f
        puts "\n\tLOADING BATCH of #{BATCH_SIZE} at +#{current_offset}..." if ENV['DEBUG']

        current_block_set = blocks.limit( BATCH_SIZE ).offset( current_offset ).to_a
        current_block_set.each_with_index do |block, i|
          values << value_generator.call(block, latest)
        end

        current_offset += BATCH_SIZE
      end

      values.compact!

      snapshot = @chain.average_snapshots.create( {
        kind: kind,
        scopeable: object_scope,
        timestamp: latest,
        interval: 'hour',
        sum: values.reduce(:+) || 0,
        count: values.count
      }.compact )
      puts "=> #{snapshot.average}" if ENV['DEBUG']

      latest = adjust_for_interval('hour', latest + 1.hour, :beginning)
      ProgressReport.instance.progress start_time, latest.to_f, target.to_f do |current|
        Time.at( current.to_i ).strftime("%Y-%m-%d %H:%M") + (object_scope ? " #{object_scope.class.name}/#{object_scope.to_param}" : '')
      end
    end
  end

  def daily_average_snapshots!( kind, object_scope=nil )
    # this function uses existing hourly snapshots to
    # generate the next level up

    # first find the latest snapshot
    latest = @chain.average_snapshots.where( { kind: kind, scopeable: object_scope, interval: 'day' }.compact ).first.try(:timestamp)

    if !latest
      # no snapshots yet, we can use the first hourly snapshot
      latest = adjust_for_interval('day', @chain.average_snapshots.where( { kind: kind, scopeable: object_scope, interval: 'hour' }.compact ).last.try(:timestamp), :beginning)
    else
      # we push 1 more {interval} since we already have the snapshot for 'latest'
      latest = adjust_for_interval('day', latest + 1.day, :beginning)
    end

    if !latest
      puts "No existing hourly snapshots for #{kind}#{" (#{object_scope.class}/#{object_scope.id})" if object_scope}." if ENV['DEBUG']
      return
    end

    if latest >= Date.today
      puts "No new daily snapshots needed for #{kind}#{" (#{object_scope.class}/#{object_scope.id})" if object_scope}." if ENV['DEBUG']
      return
    end

    # now just keep going through the {interval}s until we reach the last time period
    target = @chain.blocks.first.timestamp
    target = adjust_for_interval( 'day', target, :beginning )
    while latest <= target
      print "Generating daily average #{kind}#{" (#{object_scope.class}/#{object_scope.id})" if object_scope} snapshot for #{latest}... " if ENV['DEBUG']

      hourly_snapshots = @chain.average_snapshots
        .where( { kind: kind, scopeable: object_scope, interval: 'hour' }.compact )
        .where(
          %{ timestamp >= ? AND timestamp <= ? },
          adjust_for_interval('day', latest, :beginning),
          adjust_for_interval('day', latest, :end)
        )

      snapshot = @chain.average_snapshots.create( {
        kind: kind,
        scopeable: object_scope,
        timestamp: latest,
        interval: 'day',
        sum: hourly_snapshots.sum(:sum),
        count: hourly_snapshots.sum(:count)
      }.compact )
      puts "=> #{snapshot.average}" if ENV['DEBUG']

      latest = adjust_for_interval('day', latest + 1.day, :beginning)
    end
  end

  private

  def adjust_for_interval( interval, time, direction )
    return nil unless time
    time.public_send(:"#{direction}_of_#{interval}")
  end

end
