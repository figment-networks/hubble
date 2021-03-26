module Mina
  class Validator < Common::Resource
    STATUS_ACTIVE = 'online'.freeze
    STATUS_INACTIVE = 'offline'.freeze

    PERIOD_ACTIVE = 24.hours

    field :public_key
    field :identity_name
    field :balance, type: :integer
    field :balance_unknown, type: :integer
    field :stake, type: :integer
    field :start_time, type: :timestamp
    field :start_height
    field :last_time, type: :timestamp
    field :last_height
    field :blocks_created, type: :integer, default: 0
    field :delegations, type: :integer, default: 0
    field :account_balance, type: :integer

    def active?(time = nil)
      (time || Time.current) - last_time <= PERIOD_ACTIVE
    end

    def status
      @status ||= (active? ? STATUS_ACTIVE : STATUS_INACTIVE)
    end

    def display_name
      identity_name || public_key
    end
  end
end
