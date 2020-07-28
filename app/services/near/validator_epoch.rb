module Near
  class ValidatorEpoch < Common::Resource
    attr_accessor :epoch,
                  :last_height,
                  :last_time,
                  :expected_blocks,
                  :produced_blocks,
                  :efficiency

    def initialize(attrs = {})
      super(attrs)

      @last_time = Time.zone.parse(last_time) if last_time
    end
  end
end
