require 'rails_helper'

describe Polkadot::Client do
  describe '#validator_events' do
    subject do
      client.validator_events(
        chain: chain,
        address: '1WG3jyNqniQMRZGQUc7QD2kVLT8hkRPGMSqAb5XYQM1UDxN',
        types: types,
        start_date: start_date,
        end_date: end_date
      )
    end

    let(:client) { described_class.new(endpoint) }
    let(:chain) { build(:polkadot_chain) }
    let(:endpoint) { chain.api_url }
    let(:types) { nil }
    let(:start_date) { nil }
    let(:end_date) { nil }
    let(:response) { json_fixture('polkadot/events.json') }

    before do
      allow(client).to receive(:get).and_return(response)
    end

    it 'returns all events' do
      expect(subject.count).to eq 57
    end

    context 'with a types filter' do
      let(:types) { ['delegation_change'] }

      it 'returns only events with specified kind' do
        expect(subject.count).to eq 56
        expect(subject.first.kind).to eq 'delegation_left'
      end
    end

    context 'with a types and date filter' do
      let(:types) { ['delegation_change'] }
      let(:start_date) { '2020-12-12' }
      let(:end_date) { '2021-01-04' }

      it 'returns events with specified kind and date, sorted' do
        expect(subject.count).to eq 31
        expect(subject.first.kind).to eq 'delegation_left'
        expect(subject.first.time.to_date).to eq Date.parse('2021-01-04')
        expect(subject.last.time.to_date).to eq Date.parse('2020-12-12')
      end
    end
  end
end
