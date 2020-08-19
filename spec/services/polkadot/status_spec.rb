require 'rails_helper'

describe Polkadot::Status do
  describe '.failed' do
    subject { described_class.failed }

    it 'has a success = false attribute' do
      expect(subject.success).to eq false
      expect(subject.last_indexed_height).to eq nil
    end
  end

  describe '#sucess' do
    subject { described_class.new }

    it 'has a success = true attribute' do
      expect(subject.success).to eq true
    end
  end
end
