module Indexer
  class VotingPeriod
    include ActiveModel::Model

    attr_accessor :id,
                  :period_type,
                  :quorum,
                  :total_rolls,
                  :total_voters,
                  :period_start_block,
                  :period_start_time,
                  :period_end_block,
                  :period_end_time,
                  :quorum_reached,
                  :supermajority_reached,
                  :end_time_approximation

    def self.retrieve(id)
      resp = RestClient.get("#{Tezos::Chain.primary.indexer_api_base_url}/voting_periods/#{id}")
      data = JSON.parse(resp.body)
      new(data)
    end

    def self.list(query: nil)
      url = "#{Tezos::Chain.primary.indexer_api_base_url}/voting_periods"
      resp = RestClient.get(url, params: { query: query })
      data = JSON.parse(resp.body)
      data.map { |e| new(e) }
    end

    def self.latest
      url = "#{Tezos::Chain.primary.indexer_api_base_url}/voting_periods"
      resp = RestClient.get(url, params: { limit: 1 })
      data = JSON.parse(resp.body)
      periods = data.map { |e| new(e) }
      periods.first
    end

    def quorum_percent
      quorum.to_f / 100
    end

    def proposal?
      period_type == 'proposal'
    end

    def testing_vote?
      period_type == 'testing_vote'
    end

    def testing?
      period_type == 'testing'
    end

    def promotion_vote?
      period_type == 'promotion_vote'
    end
  end
end
