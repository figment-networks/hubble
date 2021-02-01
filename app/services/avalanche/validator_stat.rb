module Avalanche
  class ValidatorStat < Common::Resource
    field :time, type: :timestamp
    field :uptime_avg, type: :integer
  end
end
