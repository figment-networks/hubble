module Oasis
  class Validator < Common::Resource

    PERIOD_ACTIVE = 1.hour

    attr_accessor :id,
                  :created_at,
                  :updated_at,
                  :started_at_height,
                  :started_at,
                  :recent_at_height,
                  :recent_at,
                  :entity_uid,
                  :recent_address,
                  :recent_voting_power,
                  :recent_total_shares,
                  :recent_as_validator_height,
                  :recent_proposed_height,
                  :accumulated_proposed_count,
                  :accumulated_uptime,
                  :accumulated_uptime_count,
                  :uptime,
                  :last_sequences,
                  :height,
                  :time,
                  :address,
                  :proposed,
                  :voting_power,
                  :total_shares,
                  :precommit_validated,
                  :recent_tendermint_address,
                  :as_validator_height,
                  :proposed_height

    def initialize(attrs = {})
      super(attrs)
      @started_at = started_at ? Time.zone.parse(started_at) : nil
      @recent_at = recent_at ? Time.zone.parse(recent_at) : nil
      @uptime ||= accumulated_uptime.to_f / accumulated_uptime_count.to_f
    end

    # What time do we define as active?
    def active?
      Time.current - recent_at <= PERIOD_ACTIVE
    end

    def online?(height)
      recent_at_height == height
    end

    def current_uptime_percent
      (uptime * 100).round(0)
    end

    #active set history placeholders - I have to figure out how this works
    def active_set_history
      ash = []
    end

    def in_active_set?( block=nil )
      true
    end
  end
end
