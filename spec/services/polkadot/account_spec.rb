require 'rails_helper'

describe Polkadot::Account do
  let(:account) { described_class.new(attributes) }
  let(:attributes) {
    {
      "nonce": 37,
      "referendum_count": 2,
      "free": "211969710818710",
      "reserved": "10393333333332",
      "misc_frozen": "159408040804203",
      "fee_frozen": "159408040804203"
    }
  }

  context '#total' do
    subject { account.total }

    it 'returns a correct total' do
      expect(subject).to eq 222363044152042
    end
  end

  context '#misc_frozen' do
    subject { account.misc_frozen }

    it 'returns a misc_frozen that is an integer' do
      expect(subject).to eq 159408040804203
    end
  end
end
