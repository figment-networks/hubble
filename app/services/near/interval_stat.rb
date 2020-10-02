module Near
  class IntervalStat < Common::Resource
    field :time_interval, type: :timestamp
    field :count
    field :avg

    def point
      { t: time_interval.iso8601, y: avg || count }
    end
  end
end
