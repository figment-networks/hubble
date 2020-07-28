module Near
  class Validator < Common::Resource
    STATUS_ONLINE  = "online"
    STATUS_OFFLINE = "offline"

    PERIOD_ACTIVE = 1.hour

    attr_accessor :id,
                  :account_id,
                  :start_height,
                  :start_time,
                  :last_height,
                  :last_time,
                  :height,
                  :time,
                  :expected_blocks,
                  :produced_blocks,
                  :slashed,
                  :stake,
                  :efficiency,
                  :epoch,
                  :created_at,
                  :updated_at

    # Associated resources
    attr_accessor :epochs,
                  :account,
                  :blocks

    def initialize(attrs = {})
      super(attrs)

      @start_time = Time.zone.parse(start_time)
      @last_time  = Time.zone.parse(last_time)

      @account = Account.new(account)                    if account
      @epochs = epochs.map { |r| ValidatorEpoch.new(r) } if epochs
      @blocks = blocks.map { |r| Block.new(r) }          if blocks
    end

    def active?
      @actoive ||= (Time.current - last_time < PERIOD_ACTIVE)
    end

    def status
      active? ? STATUS_ONLINE : STATUS_OFFLINE
    end
  end
end
