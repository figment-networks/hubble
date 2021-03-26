module Mina
  class BlockTime < Common::Resource
    include TimeHelper

    field :start_height
    field :end_height
    field :start_time
    field :end_time
    field :count
    field :diff
    field :avg

    def minutes_avg
      seconds_in_minutes(avg).round(2)
    end
  end
end
