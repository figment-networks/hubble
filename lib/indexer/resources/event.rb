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

    def self.list(cycle_id: 'current', page: nil, types: nil, before_timestamp: nil, after_timestamp: nil, after_height: nil, paginate: true)
      url = if cycle_id.present?
              "#{Tezos::Chain.primary.indexer_api_base_url}/cycles/#{cycle_id}/events"
            else
              "#{Tezos::Chain.primary.indexer_api_base_url}/events"
            end
      resp = RestClient.get(url, params: {
                              page: page,
                              types: types,
                              before_timestamp: before_timestamp,
                              after_timestamp: after_timestamp,
                              after_height: after_height,
                              paginate: paginate
                            })
      data = JSON.parse(resp.body)

      json = {}
      json[:pagination] = data['pagination']['vars']
      json[:events] = data['events'].map { |attrs| new(attrs) }
      json
    end

    def kind_string
      type.to_s
    end

    def baker_name
      sender_name
    end

    def baker_address
      sender_id
    end

    def offender_name
      receiver_name
    end

    def offender_address
      receiver_id
    end

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

    def subscription_address
      case type
      when 'missed_endorsement'
        sender_id
      when 'missed_bake'
        sender_id
      when 'baker_activated'
        sender_id
      when 'baker_deactivated'
        sender_id
      when 'steal'
        sender_id
      when 'double_bake'
        receiver_id
      when 'double_endorsement'
        receiver_id
      end
    end

    def timestamp=(val)
      @timestamp = if val.is_a?(String)
                     Time.parse(val)
                   else
                     val
                   end
    end

    def to_s
      case type
      when 'missed_endorsement'
        "Baker #{baker_long_name} missed an endorsement at slot #{slot} for block #{block_id}"
      when 'missed_bake'
        "Baker #{baker_long_name} missed a bake at block #{block_id}"
      when 'baker_activated'
        "Baker #{baker_long_name} was activated around block #{block_id}"
      when 'baker_deactivated'
        "Baker #{baker_long_name} was deactivated around block #{block_id}"
      when 'steal'
        "Baker #{baker_long_name} stole a bake at block #{block_id}!"
      when 'double_bake'
        "Baker #{baker_long_name} accused #{offender_long_name} of a Double Bake at block #{related_block_id}"
      when 'double_endorsement'
        "Baker #{baker_long_name} accused #{offender_long_name} of a Double Endorsement at block #{related_block_id}"
      end
    end
  end
end
