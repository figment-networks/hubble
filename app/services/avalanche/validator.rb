module Avalanche
  class Validator < Common::Resource
    field :node_id
    field :stake_amount, type: :integer
    field :stake_percent
    field :potential_reward
    field :reward_address
    field :active
    field :active_start_time, type: :timestamp
    field :active_end_time, type: :timestamp
    field :active_progress_percent
    field :uptime, type: :integer
    field :delegated_amount, type: :integer
    field :delegation_fee, type: :integer
    field :capacity, type: :integer
    field :capacity_percent

    def display_name
      @display_name.presence || account_details&.display_name || node_id
    end

    def uptime
      @uptime.round(2)
    end

    def active?
      !!@active
    end

    def capacity_percent
      @capacity_percent.floor(2)
    end

    def total_stake
      stake_amount + delegated_amount
    end
  end
end
