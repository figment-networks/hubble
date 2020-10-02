require 'rails_helper'

describe Common::BlockDecorator do
  let(:instance) { described_class.new(model, status) }
  let(:model) { double(height: 10) }
  let(:status) { double }

  describe '#previous_block' do
    subject { instance.previous_block }

    it 'returns previous block number' do
      expect(subject).to eq 9
    end
  end

  describe '#has_previous_block?' do
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

  describe '#has_next_block?' do
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
