module Indexer
  class Block
    include ActiveModel::Model

    attr_accessor :id, :cycle_id, :missed, :baker_id, :intended_baker_id, :baker_priority,
                  :missed_slot_details, :missed_bakes, :timestamp

    alias height id

    def self.retrieve(id = 'latest')
      resp = RestClient.get("#{Tezos::Chain.primary.indexer_api_base_url}/blocks/#{id}")
      data = JSON.parse(resp.body)
      new(data)
    end

    def self.list(from: nil, after: nil)
      url = "#{Tezos::Chain.primary.indexer_api_base_url}/blocks"
      resp = RestClient.get(url, params: { from: from, after: after })
      data = JSON.parse(resp.body)
      data.map { |attrs| new(attrs) }
    end

    def missed?
      missed
    end

    def stolen?
      missed?
    end

    def timestamp=(val)
      @timestamp = if val.is_a?(String)
                     Time.parse(val)
                   else
                     val
                   end
    end
  end
end
