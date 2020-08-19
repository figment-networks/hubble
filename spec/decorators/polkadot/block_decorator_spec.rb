require 'rails_helper'

describe Polkadot::BlockDecorator do
  let(:instance) { described_class.new(model, status) }
  let(:model) { double(height: 10) }
  let(:status) { double }

  context '#previous_block' do
    subject { instance.previous_block }

    it 'returns previous block number' do
      expect(subject).to eq 9
    end
  end

  context '#has_previous_block?' do
    subject { instance.has_previous_block? }

    context 'when there is a previous block' do
      it 'returns true' do
        expect(subject).to eq true
      end
    end

    context 'when there is no previous block' do
      let(:model) { double(height: 1) }

      it 'returns true' do
        expect(subject).to eq false
      end
    end
  end

  context '#has_next_block?' do
    subject { instance.has_next_block? }
    let(:status) { double(last_indexed_height: 10) }

    context 'when there is a next block' do
      let(:model) { double(height: 5) }

      it 'returns true' do
        expect(subject).to eq true
      end
    end

    context 'when there is no next block' do
      it 'returns true' do
        expect(subject).to eq false
      end
    end
  end
end
