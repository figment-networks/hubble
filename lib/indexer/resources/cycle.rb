require_relative 'baking_stats'
require_relative 'endorsing_stats'

module Indexer
  class Cycle
    include ActiveModel::Model

    attr_accessor :number, :start_time, :end_time, :start_height, :end_height,
                  :missed_priorities, :missed_slots, :snapshot_cycle_number,
                  :snapshot_height, :total_rolls, :seconds_remaining,
                  :blocks_left, :url, :rewards_unfrozen_cycle_number,
                  :cached_baking_stats, :cached_endorsing_stats

    def self.retrieve(id = 'current')
      id ||= 'current'
      resp = RestClient.get("#{Tezos::Chain.primary.indexer_api_base_url}/cycles/#{id}")
      data = JSON.parse(resp.body)
      new(data)
    end

    def start_time
      Time.at(@start_time)
    end

    def end_time
      Time.at(@end_time)
    end

    def current?
      end_time > Time.current
    end

    def percentage_complete
      (4096 - blocks_left) / 4096.0
    end

    def cached_baking_stats
      @bakings_stats ||= @cached_baking_stats.transform_values! do |v|
        v.is_a?(Integer) ? v : Indexer::BakingStats.new(v.symbolize_keys)
      end
    end

    def cached_endorsing_stats
      @endorsing_stats ||= @cached_endorsing_stats.transform_values! do |v|
        Indexer::EndorsingStats.new(v.symbolize_keys)
      end
    end
  end
end
