require 'rails_helper'
require 'indexer/resources/event'

RSpec.describe AlertSubscription do
  context 'Tezos' do
    let(:subscription) { AlertSubscription.new(event_kinds: ['balance_change'], data: { percent_change: 5 }) }
    let(:event) { Indexer::Event.new(type: 'balance_change') }

    describe '#wants_event?' do
      it 'returns true when positive event percent change is greater than preference' do
        event.percentage_change = 0.10
        expect(subscription).to be_wants_event(event)
      end

      it 'returns true when positive event percent change is equal to preference' do
        event.percentage_change = 0.05
        expect(subscription).to be_wants_event(event)
      end

      it 'returns true when negative event percent change is greater than preference' do
        event.percentage_change = -0.15
        expect(subscription).to be_wants_event(event)
      end

      it 'returns false when event percent change is less than preference' do
        event.percentage_change = -0.01
        expect(subscription).not_to be_wants_event(event)
      end

      it 'returns false when the user is not subscribed to balance change events' do
        subscription.event_kinds = ['missed_bake']
        event.percentage_change = 0.10
        expect(subscription).not_to be_wants_event(event)
      end
    end
  end
end
