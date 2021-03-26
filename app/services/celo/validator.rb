module Celo
  class Validator < Common::Resource
    field :address
    field :name
    field :metadata_url
    field :recent_name
    field :recent_metadata_url
    field :uptime, type: :float, default: 0
    field :started_at, type: :timestamp
    field :recent_at, type: :timestamp
    field :affiliation
    field :score, type: :float, default: 0
    field :validator_group

    def factored_commission
      validator_group&.factored_commission
    end

    def display_name
      name.presence || recent_name.presence || address
    end

    def metadata_url
      @metadata_url || recent_metadata_url
    end
  end
end
