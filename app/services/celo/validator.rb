module Celo
  class Validator < Common::Resource
    field :address
    field :name
    field :metadata_url
    field :recent_name
    field :recent_metadata_url
    field :uptime, type: :integer, default: 1
    field :started_at, type: :timestamp
    field :recent_at, type: :timestamp
    field :affiliation
    field :score, type: :float, default: 0
    field :validator_group

    delegate :factored_commission, to: :validator_group

    def display_name
      name || recent_name || address
    end

    def metadata_url
      @metadata_url || recent_metadata_url
    end

    # TODO: replace with proper data, but no idea how `8.683456024306e+23` translates to %
    # https://github.com/figment-networks/indexer-mocks/pull/23/files#r534115832
    def score
      99.98
    end
  end
end
