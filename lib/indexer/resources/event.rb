module Indexer
  class Event
    include ActiveModel::Model

    attr_accessor :id,
                  :type,
                  :block_id,
                  :related_block_id,
                  :sender_id,
                  :sender_name,
                  :receiver_id,
                  :receiver_name,
                  :priority,
                  :slot,
                  :reward

    def self.list(cycle_id: "current", page: nil, types: nil, after_timestamp: nil, after_height: nil, paginate: true)
      url = if cycle_id.present?
        "#{Tezos::Chain.primary.indexer_api_base_url}/cycles/#{cycle_id}/events"
      else
        "#{Tezos::Chain.primary.indexer_api_base_url}/events"
      end
      resp = RestClient.get(url, params: {
        page: page,
        types: types,
        after_timestamp: after_timestamp,
        after_height: after_height,
        paginate: paginate
      })
      data = JSON.parse(resp.body)

      json = {}
      json[:pagination] = data["pagination"]["vars"]
      json[:events] = data["events"].map { |attrs| new(attrs) }
      json
    end

    def baker_name; sender_name; end
    def baker_address; sender_id; end

    def offender_name; receiver_name; end
    def offender_address; receiver_id; end

    def baker_long_name
      baker_name.presence || baker_address
    end

    def baker_short_name
      baker_name.presence || baker_address.truncate(30)
    end

    def offender_long_name
      offender_name.presence || offender_address
    end

    def offender_short_name
      offender_name.presence || offender_address.truncate(30)
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
