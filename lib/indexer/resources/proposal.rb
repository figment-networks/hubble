module Indexer
  class Proposal
    include ActiveModel::Model

    attr_accessor :id,
                  :name,
                  :description,
                  :discussion_url,
                  :submitted_time,
                  :submitted_block,
                  :start_period,
                  :passed_prop_period,
                  :passed_eval_period,
                  :is_promoted,
                  :status

    def self.retrieve(id)
      resp = RestClient.get("#{Tezos::Chain.primary.indexer_api_base_url}/proposals/#{id}")
      data = JSON.parse(resp.body)
      new(data)
    end

    def self.list(query: nil)
      url = "#{Tezos::Chain.primary.indexer_api_base_url}/proposals"
      resp = RestClient.get(url, params: { query: query })
      data = JSON.parse(resp.body)
      data.map { |e| new(e) }
    end

    def eval_period_id
      self.start_period + 1
    end
    def testing_period_id
      self.start_period + 2
    end
    def promotion_period_id
      self.start_period + 3
    end

    def is_active?
      (self.status != 'rejected') && (self.status != 'promoted')
    end
  end
end
