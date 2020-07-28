module Indexer
  class Ballot
    include ActiveModel::Model

    attr_accessor :id,
                  :voting_period_id,
                  :proposal_id,
                  :baker_id,
                  :vote,
                  :rolls,
                  :created_at,
                  :submitted_block,
                  :prop_name

    def self.list
      query = {}
      url = "#{Tezos::Chain.primary.indexer_api_base_url}/ballots"
      resp = RestClient.get(url, params: { query: query })
      data = JSON.parse(resp.body)
      data.map { |e| new(e) }
    end

    def self.ballots_by_period(period)
      url = "#{Tezos::Chain.primary.indexer_api_base_url}/ballots"
      resp = RestClient.get(url, params: { voting_period_id: period })
      data = JSON.parse(resp.body)
      data.map { |e| new(e) }
    end
  end
end
