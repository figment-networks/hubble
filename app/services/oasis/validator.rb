module Oasis
  class Validator < Common::Resource
    PERIOD_ACTIVE = 1.hour

    field :id
    field :created_at, type: :timestamp
    field :updated_at, type: :timestamp
    field :started_at_height
    field :started_at, type: :timestamp
    field :recent_at_height
    field :recent_at, type: :timestamp
    field :entity_uid
    field :recent_address
    field :recent_voting_power
    field :recent_total_shares
    field :recent_active_escrow_balance
    field :recent_commission
    field :recent_rewards
    field :recent_as_validator_height
    field :recent_proposed_height
    field :accumulated_proposed_count
    field :accumulated_uptime, type: :float
    field :accumulated_uptime_count, type: :float
    field :active_escrow_balance
    field :logo_url
    field :entity_name
    field :uptime, type: :float
    field :last_sequences
    field :height
    field :time, type: :timestamp
    field :address
    field :proposed
    field :voting_power
    field :total_shares
    field :precommit_validated
    field :recent_tendermint_address
    field :as_validator_height
    field :proposed_height
    field :delegations

    def self.failed(id)
      new('address' => id)
    end

    def initialize(attr)
      super(attr)
      @delegations = []
      @uptime ||= accumulated_uptime / accumulated_uptime_count if accumulated_uptime
    end

    def long_name
      entity_name.blank? ? address : entity_name
    end

    def short_name(len = 30)
      long_name.truncate(len)
    end

    def active?
      Time.current - recent_at <= PERIOD_ACTIVE
    end

    def online?(height)
      recent_at_height == height
    end

    def current_uptime_percent
      (uptime * 100).round(0)
    end

    # active set history placeholders - I have to figure out how this works
    def active_set_history
      ash = []
    end

    def in_active_set?(_block = nil)
      true
    end
  end
end
