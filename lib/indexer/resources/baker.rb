require "indexer/resources/baking_stats"
require "indexer/resources/endorsing_stats"

module Indexer
  class Baker
    include ActiveModel::Model

    attr_accessor :id, :name, :url, :lifetime_baking_stats, :lifetime_endorsing_stats,
                  :baking_stats_history, :endorsing_stats_history

    alias_attribute :address, :id

    def self.retrieve(address)
      resp = RestClient.get("#{Tezos::Chain.primary.indexer_api_base_url}/bakers/#{address}")
      data = JSON.parse(resp.body)
      new(data)
    end

    def self.list(query: nil)
      url = "#{Tezos::Chain.primary.indexer_api_base_url}/bakers"
      resp = RestClient.get(url, params: { query: query })
      data = JSON.parse(resp.body)
      data.map { |e| new(e) }
    end

    def long_name
      name.presence || address
    end

    def short_name
      name.presence || address.truncate(30)
    end

    def lifetime_baking_stats
      BakingStats.new(@lifetime_baking_stats.symbolize_keys)
    end

    def lifetime_endorsing_stats
      EndorsingStats.new(@lifetime_endorsing_stats.symbolize_keys)
    end

    def baking_stats_history
      @baking_stats ||= @baking_stats_history.transform_values! { |v| BakingStats.new(v.symbolize_keys) }
    end

    def endorsing_stats_history
      @endorsing_stats ||= @endorsing_stats_history.transform_values! { |v| EndorsingStats.new(v.symbolize_keys) }
    end
  end
end
