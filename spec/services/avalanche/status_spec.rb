require 'rails_helper'

describe Avalanche::Status do
  describe '.failed' do
    subject { described_class.failed }

    it 'has a success = false attribute' do
      expect(subject.success).to eq false
    end
  end

  describe '#success' do
    subject { described_class.new }

    it 'has a success = true attribute' do
      expect(subject.success).to eq true
    end
  end
end
