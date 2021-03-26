module Celo
  class ValidatorGroup < Common::Resource
    COMMISSION_PERCENTAGE_FACTOR = 10 ** 22

    field :address
    field :name
    field :recent_name
    field :recent_metadata_url
    field :commission, type: :integer, default: 0
    field :active_votes, type: :integer, default: 0
    field :pending_votes, type: :integer, default: 0
    field :members_avg_uptime, type: :integer, default: 0
    field :uptime, type: :integer, default: 1 # TODO: this will be added in the indexer, replace default with 0
    field :started_at, type: :timestamp
    field :recent_at, type: :timestamp

    def display_name
      name.presence || recent_name.presence || address
    end

    def votes
      active_votes + pending_votes
    end

    def factored_commission
      commission.to_f / COMMISSION_PERCENTAGE_FACTOR
    end

    def online?
      members_avg_uptime != 0
    end
  end
end
