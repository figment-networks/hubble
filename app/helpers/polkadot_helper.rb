module PolkadotHelper
  def polkadot_event_to_partial_path(event)
    "/common/redesign/validator_events/#{event.kind_class}"
  end
end
