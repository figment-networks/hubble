module Mina
  class Validator < Common::Resource
    STATUS_ACTIVE = 'active'.freeze
    STATUS_INACTIVE = 'inactive'.freeze

    PERIOD_ACTIVE = 96.hours

    field :account
    field :balance, type: :integer
    field :balance_unknown, type: :integer
    field :start_time, type: :timestamp
    field :start_height
    field :last_time, type: :timestamp
    field :last_height
    field :blocks_created, type: :integer, default: 0
    field :delegated_accounts, type: :integer, default: 0
    field :delegated_balance
    field :account_balance, type: :integer

    def active?(time = nil)
      (time || Time.current) - last_time <= PERIOD_ACTIVE
    end

    def status
      @status ||= (active? ? STATUS_ACTIVE : STATUS_INACTIVE)
    end
  end
end
