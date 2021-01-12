module Celo
  class ValidatorGroup < Common::Resource
    COMMISSION_PERCENTAGE_FACTOR = 10 ** 21

    field :address
    field :name
    field :recent_name
    field :recent_metadata_url
    field :commission, type: :integer, default: 0
    field :active_votes, type: :integer, default: 0
    field :pending_votes, type: :integer, default: 0
    field :uptime, type: :integer, default: 1
    field :started_at, type: :timestamp
    field :recent_at, type: :timestamp

    def display_name
      name || recent_name || address
    end

    def votes
      active_votes + pending_votes
    end

    def factored_commission
      commission.to_f / COMMISSION_PERCENTAGE_FACTOR
    end
  end
end
