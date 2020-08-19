require 'rails_helper'

describe Polkadot::Validator do
  let(:validator) { described_class.new(attributes) }
  let(:attributes) { { commission: commission } }
  let(:commission) { 1200000000 }

  describe '#commission_percentage' do
    subject { validator.commission_percentage }

    it 'returns a correct percentage' do
      expect(subject).to eq 12
    end

    context 'zero commission' do
      let(:commission) { 0 }

      it 'returns a correct percentage' do
        expect(subject).to eq 0
      end
    end
  end
end
