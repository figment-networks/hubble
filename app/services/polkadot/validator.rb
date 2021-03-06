module Polkadot
  class Validator < Common::Resource
    COMMISSION_PERCENTAGE_FACTOR = 10 ** 7

    field :stash_account
    field :accumulated_uptime, default: 0
    field :accumulated_uptime_count, default: 1
    field :online
    field :total_stake, type: :integer, default: 0
    field :commission, type: :integer, default: 0
    field :own_stake, type: :integer, default: 0
    field :reward_points, type: :integer, default: 0
    field :started_at, type: :timestamp
    field :display_name
    field :account_details
    field :indexer_uptime, type: :float
    field :network, type: Prime::Network

    alias online? online

    def initialize(attributes, network: nil)
      super(attributes)
      @indexer_uptime = attributes['uptime']
      @network = network if network
    end

    def address
      stash_account
    end

    def display_name
      @display_name.presence || account_details&.display_name || stash_account
    end

    def factored_commission
      commission.to_f / COMMISSION_PERCENTAGE_FACTOR
    end

    # TO DO: Get clarification on these numbers, Fig validators are all zero but
    # also have 'uptime' with a legit %
    def uptime
      return 0 if accumulated_uptime_count.to_f <= 0

      accumulated_uptime.to_f / accumulated_uptime_count.to_f
    end

    def account_details
      @account_details ||= Polkadot::AccountDetails.failed(stash_account)
    end
  end
end
