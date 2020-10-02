module Near
  class Validator < Common::Resource
    STATUS_ONLINE  = 'online'.freeze
    STATUS_OFFLINE = 'offline'.freeze

    PERIOD_ACTIVE = 1.hour

    field :id
    field :account_id
    field :start_height
    field :start_time, type: :timestamp
    field :last_height
    field :last_time, type: :timestamp
    field :height
    field :time
    field :expected_blocks
    field :produced_blocks
    field :slashed
    field :stake
    field :efficiency
    field :epoch
    field :created_at
    field :updated_at

    # Associated resources
    field :epochs
    field :account
    field :blocks

    def initialize(attrs = {})
      super(attrs)
      @account = Account.new(attrs[:account])                    if attrs[:account]
      @epochs = attrs[:epochs].map { |r| ValidatorEpoch.new(r) } if attrs[:epochs]
      @blocks = attrs[:blocks].map { |r| Block.new(r) }          if attrs[:blocks]
    end

    def active?
      @active ||= (Time.current - last_time < PERIOD_ACTIVE)
    end

    def status
      active? ? STATUS_ONLINE : STATUS_OFFLINE
    end
  end
end
