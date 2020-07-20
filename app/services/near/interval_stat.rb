module Near
  class IntervalStat < Common::Resource
    attr_accessor :time_interval,
                  :count,
                  :avg

    def initialize(attrs = {})
      super(attrs)

      @time_interval = Time.zone.parse(time_interval)
    end

    def point
      { t: time_interval.iso8601, y: avg || count }
    end
  end
end
