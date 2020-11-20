class Common::AlertSubscriptionNotifier
  def initialize(type, date = nil)
    @type = type.to_sym
    @date = date
  end

  def run!
    if @type == :daily && @date.nil?
      raise ArgumentError, 'Specify date for daily digest.'
    end

    # find users who are eligible for a notification
    eligible = @type == :instant ?
      AlertSubscription.eligible_for_instant_alert :
      AlertSubscription.daily_digest_due

    total = eligible.count

    puts "Sending #{@type} alerts to #{total} potential event subscriptions at #{Time.now.utc.strftime(TASK_DATETIME_FORMAT)}..."

    limit = 100
    offset = 0
    loop do
      subs = eligible.limit(limit).offset(offset)
      break if subs.empty?

      subs.each { |sub| send(:"run_#{@type}_for!", sub) }
      offset += limit
    end

    puts "Completed at #{Time.now.utc.strftime(TASK_DATETIME_FORMAT)}"
  end

  def run_daily_for!(sub)
    user = sub.user
    alertable = sub.alertable

    print "Handling #{@type} alerts for user #{user.id} (#{user.email}) re: #{alertable.class.name}/#{alertable.to_param} on #{@date.to_date}... "

    if alertable.chain.failing_sync?
      puts "Chain #{alertable.chain.name} is not syncing, do not send daily digest."
      return
    end

    # now find all events for the alertable since the last alert
    if Common.remotely_indexed?(alertable.chain)
      events = alertable.chain.get_events_for_alert(sub, 1.day.seconds.to_i, @date)
    else
      events = alertable.events.where(
        'timestamp >= ? AND timestamp <= ?',
        @date.beginning_of_day, @date.end_of_day
      )
    end

    print "\tNotifying about #{events.count} events..." if ENV['DEBUG']

    # we don't filter, just send everything that happened that day
    if alertable.chain.respond_to?(:alert_delivery_method) && alertable.chain.alert_delivery_method == :telegram
      Telegram::Message.send_tezos_alert(subscription: sub, events: events, type: :daily, date: @date)
    else
      AlertMailer.with(sub: sub, events: events, date: @date).daily.deliver_now
    end
    sub.update last_daily_at: Time.now.utc, daily_count: sub.daily_count + 1
    puts 'DONE'
  end

  def run_instant_for!(sub)
    user = sub.user
    alertable = sub.alertable

    print "Handling #{@type} alerts for user #{user.id} (#{user.email}) re: #{alertable.class.name}/#{alertable.to_param}... "

    # now find all events for the alertable since the last alert
    if Common.remotely_indexed?(alertable.chain)
      events = alertable.chain.get_events_for_alert(sub, ALERT_MINIMUM_TIMEOUT * 60)
    else
      events = alertable.events.where('timestamp > ?', sub.last_instant_at)
    end

    puts "\tConsidering #{events.count} events..." if ENV['DEBUG']

    # filter out events which the user does not want
    events = events.select { |event| sub.wants_event?(event) }

    if events.count > 0
      print "notifying about #{events.count} events... "
      if alertable.chain.respond_to?(:alert_delivery_method) && alertable.chain.alert_delivery_method == :telegram
        Telegram::Message.send_tezos_alert(subscription: sub, events: events, type: :instant, date: @date)
      else
        AlertMailer.with(sub: sub, events: events).instant.deliver_now
      end
      sub.update last_instant_at: Time.now.utc, instant_count: sub.instant_count + 1
      puts 'DONE'
    else
      puts 'DONE (no events)'
    end
  end
end
