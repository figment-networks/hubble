require 'rails_helper'

describe Polkadot::Validator do
  describe '#uptime' do
    subject { validator.uptime }

    let(:validator) { described_class.new(accumulated_uptime: 0, accumulated_uptime_count: 0) }

    it 'returns 0 uptime if accumulated_uptime_count is 0' do
      expect(subject).to eq 0
    end
  end
end
