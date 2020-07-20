module Near
  class Account < Common::Resource
    attr_accessor :id,
                  :name,
                  :start_height,
                  :start_time,
                  :last_height,
                  :last_time,
                  :balance,
                  :staking_balance,
                  :created_at,
                  :updated_at

    def initialize(attrs = {})
      super(attrs)

      @balance = balance&.to_i
      @staking_balance = @staking_balance&.to_i

      @start_time = Time.zone.parse(start_time)
      @last_time  = Time.zone.parse(last_time)
      @created_at = Time.zone.parse(created_at)
      @updated_at = Time.zone.parse(updated_at)
    end
  end
end
