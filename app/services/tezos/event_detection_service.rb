require 'indexer/resources/block'
require 'indexer/resources/event'

module Tezos
  class EventDetectionService
    def detect_events!(chain)
      chain.reload
      latest_block = Indexer::Block.retrieve('latest')
      latest_event_height = chain.latest_event_height || latest_block.height - 1

      # Update the chain now so we don't pull in duplicates if this runs
      # again before the first run finishes
      chain.update(latest_event_height: latest_block.height)

      # This job runs every minute. Only look for events in last 5 minutes so we don't
      # bombard people with notifications about old events during a historical sync
      data = Indexer::Event.list(
        cycle_id: nil,
        after_height: latest_event_height,
        after_timestamp: 5.minutes.ago.to_i,
        paginate: false
      )

      puts "FOUND #{data[:events].length} EVENTS"
      data[:events].each do |event|
        message = case event.type
                  when 'missed_endorsement'
                    "Baker #{event.baker_long_name} just missed an endorsement at slot #{event.slot} for block #{event.block_id}"
                  when 'missed_bake'
                    "Baker #{event.baker_long_name} just missed a bake at block #{event.block_id}"
                  when 'steal'
                    "Baker #{event.baker_long_name} just stole a bake at block #{event.block_id}!"
                  when 'double_bakes'
                    "Baker #{event.baker_long_name} just accused #{event.offender_long_name} of a Double Bake at block #{event.related_block_id}"
                  when 'double_endorsement'
                    "Baker #{event.baker_long_name} just accused #{event.offender_long_name} of a Double Endorsement at block #{event.related_block_id}"
                  end

        address = case event.type
                  when 'missed_endorsement'
                    event.sender_id
                  when 'missed_bake'
                    event.sender_id
                  when 'steal'
                    event.sender_id
                  when 'double_bakes'
                    event.receiver_id
                  when 'double_endorsement'
                    event.receiver_id
                  end

        User.subscribed_to_baker(address).with_telegram_account.each do |user|
          Telegram::Message.send(
            account: user.telegram_account,
            message: message
          )
        end
      end
    end
  end
end
