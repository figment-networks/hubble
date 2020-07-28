module Near
  class BlockTime < Common::Resource
    attr_accessor :start_height,
                  :end_height,
                  :start_time,
                  :end_time,
                  :count,
                  :diff,
                  :avg
  end
end
